module BitArrays32 {
  use AllLocalesBarriers;
  use BitOps;
  use BlockDist;
  use CopyAggregation;
  use super.Errors;
  use super.Internal;

  type bit32Index = int;

  pragma "no doc"
  const allOnes : uint(32) = 0b11111111111111111111111111111111;

  pragma "no doc"
  const one : uint(32) = 1;

  pragma "no doc"
  const packSize : bit32Index = 32;

  pragma "no doc"
  proc _createReminderMaskFromSizeAndReminder(size : bit32Index, hasRemaining : bool) {
    if hasRemaining then
      return (1 << (size % packSize)) : uint(32) - one;
    else
      return allOnes;
  }

  /* BitArray32 is an array of boolean values stored packed together as 32 bit words. All boolean values are mapped one-to-one to a bit value in memory. */
  class BitArray32 {
    pragma "no doc"
    var bitDomain : domain(rank=1, idxType=bit32Index, stridable=false);

    pragma "no doc"
    var bitSize : bit32Index;

    pragma "no doc"
    var hasRemaining : bool;

    pragma "no doc"
    var values : [bitDomain] uint(32) = noinit;

    /* Create a bit array of a given size.

       :arg size: The size of the bit array
       :arg locales: What nodes to distibute the values over
     */
    proc init(size : bit32Index, targetLocales=Locales) {
      this.complete();
      var hasRemaining = (size % packSize) != 0;
      var sizeAsInt : bit32Index = getNumberOfBlocks(hasRemaining, packSize, size);
      var lastIdx = sizeAsInt - 1;
      var Space = {0..lastIdx};
      var bitDomain : domain(rank=1, idxType=bit32Index, stridable=false) dmapped Block(boundingBox=Space, targetLocales=targetLocales) = Space;
      var values : [bitDomain] uint(32);
      this.bitDomain = bitDomain;
      this.bitSize = size;
      this.hasRemaining = hasRemaining;
      this.values = values;
    }

    /* Create a bit array from a given set of values. The input values are copied inte the bit array.

       :arg values: The bit array.
     */
    proc init(const ref values : [] uint(32), size : bit32Index) {
      this.complete();
      assert(!values.isAssociative());
      assert(!values.isSparse());
      assert(values.isRectangular());
      // Compare sizes from blocks of 32 bits and given size.
      // Make sure the the number of bits in a block fits size or size + 1
      assert(findNumberOfBlocks(values) / 2 == (size / packSize) / 2);
      var hasRemaining = (size % packSize) != 0;
      this.bitDomain = values.domain;
      this.bitSize = size;
      this.hasRemaining = hasRemaining;
      this.values = reshape(values, values.domain);
    }

    pragma "no doc"
    proc _bitshiftLeftNBits(shift : integral) {
      assert(shift >= 0 && shift < packSize);
      var mainMask = this._createMainMask(shift);
      var rollOverMask = this._createShiftRolloverMask(shift);

      var lastValue = this.values[this.values.domain.first];

      var D = this.values.domain[this.values.domain.first + 1..];
      var DBefore = this.values.domain[..this.values.domain.last - 1];
      // Copy the value value into the value at index
      forall (i, iBefore) in zip(D, DBefore) with (var aggregator = new SrcAggregator(uint(32))) {
        aggregator.copy(this.values[i], ((this.values[i] << shift) & mainMask) | ((this.values[iBefore] << shift) & rollOverMask));
      }

      on Locales[this.values.domain.first] do
        this.values[this.values.domain.first] = ((this.values[this.values.domain.first] << shift) & mainMask) | ((lastValue << shift) & rollOverMask);
    }

    pragma "no doc"
    proc _bitshiftLeft(shift : integral) {
      if shift % packSize == 0 && shift > 0 {
        this._bitshiftLeft32Bits();
        var nextShift = shift - packSize;
        this._bitshiftLeft(nextShift);
      } else if shift > 0 {
        var shiftNow = shift % packSize;
        this._bitshiftLeftNBits(shiftNow);
        var nextShift = shift - shiftNow;
        this._bitshiftLeft(nextShift);
      }
    }

    pragma "no doc"
    proc _bitshiftRight(shift : integral) {
      if shift % packSize == 0 && shift > 0 {
        this._bitshiftRight32Bits();
        var nextShift = shift - packSize;
        this._bitshiftRight(nextShift);
      } else if shift > 0 {
        var shiftNow = shift % packSize;
        this._bitshiftRightNBits(shiftNow);
        var nextShift = shift - shiftNow;
        this._bitshiftRight(nextShift);
      }
    }

    pragma "no doc"
    proc _createMainMask(shift : integral) : uint(32) {
      return ((1 << shift:int(32)) - 1) : uint(32);
    }

    pragma "no doc"
    proc _createShiftRolloverMask(shift : integral) : uint(32) {
      const one = 1 : uint(32);
      return allOnes - ((one << shift:int(32)) - 1) : uint(32);
    }

    pragma "no doc"
    proc _createReminderMask() : uint(32) {
      return _createReminderMaskFromSizeAndReminder(this.bitSize, this.hasRemaining);
    }

    /* Test if all the values are true

       :returns: `true` if all the values are `true`
       :rtype: `bool`
     */
    proc all() : bool {
      return unsignedAll(this.hasRemaining, packSize, this.size(), this.values);
    }

    /* Test if any of the values are true

      :returns: `true` if any of the values are `true`
      :rtype: `bool`
    */
    proc any() : bool {
      return unsignedAny(this.values);
    }


    /* Looks up value at `idx`.

       :arg idx: The index in the bitarray to look up.

       :returns: value at `idx`
       :rtype: `bool`

       :throws BitRangeError: If `idx` is outside the range [1..size).
    */
    proc at(idx : bit32Index) : bool throws {
      if idx >= this.size() then
        throw new BitRangeError();
      return unsignedAt(packSize, this.values, idx);
    }

    /* Compares two bit arrays by values.

       :returns: `true` if the two bit arrays has identical values.
       :rtype: `bool`
     */
    proc equals(rhs : BitArray32) : bool {
      return this.bitSize == rhs.bitSize && this.bitDomain == rhs.bitDomain && this.hasRemaining == rhs.hasRemaining && this.values.equals(rhs.values);
    }

    /* Set all the values to `true`.
     */
    proc fill() {
      this.values = allOnes;
      on this.values[this.values.domain.last] do
        this.values[this.values.domain.last] &= this._createReminderMask();
    }

    /* Count the number of values set to `true`.

       :returns: The count.
       :rtype: `int`
     */
    proc popcount() : uint(32) {
      return _popcount(values);
    }

    /* Reverse the ordering of the values. The last value becomes the first value. The second last value becomes the second first value. And so on.
     */
    proc reverse() {
      this.values.reverse();
      forall i in this.values.domain do
        this.values[i] = reverse32(this.values[i]);

      if this.hasRemaining then
        this._bitshiftLeftNBits(this.bitSize % packSize);
    }

    pragma "no doc"
    proc _bitshiftLeft32Bits() {
      var D = this.values.domain;
      var destination : [D] uint(32) = 0;
      var DExceptFirst = D[(this.values.first + 1)..this.values.last];
      forall (i, j) in zip(DExceptFirst, D) with (var aggregator = new SrcAggregator(uint(32))) {
        aggregator.copy(destination[i], this.values[j]);
        aggregator.flush();
        aggregator.copy(this.values[i], destination[i]);
      }
    }

    pragma "no doc"
    proc _rotateLeftWholeBlock() {
      var lastValue : uint(32) = 0;
      on this.values[this.values.domain.first] do
        lastValue = this.values[this.values.domain.last];

      var D = this.values.domain[this.values.domain.first + 1..];
      var DBefore = this.values.domain[..this.values.domain.last - 1];
      // Copy the value value into the value at index
      forall (i, j) in zip(D, DBefore) with (var aggregator = new SrcAggregator(uint(32))) do
        aggregator.copy(this.values[i], this.values[j]);

      // Copy the last value into the first value
      on this.values[this.values.domain.first] do
        this.values[this.values.domain.first] = lastValue;
    }

    pragma "no doc"
    proc _rotateLeftNBits(shiftNow : integral) {
      var lastValue = BitOps.rotl(this.values[this.values.domain.last], shiftNow);
      var firstValue = BitOps.rotl(this.values[this.values.domain.first], shiftNow);

      var D = this.values.domain[this.values.domain.first + 1..];
      var DBefore = this.values.domain[..this.values.domain.last - 1];
      forall (i, iBefore) in zip(D, DBefore) {
        var mainMask = this._createMainMask(shiftNow);
        var rollOverMask = this._createShiftRolloverMask(shiftNow);

        // Rotate the value by `shift` bits
        var value = BitOps.rotl(this.values[i], shiftNow);
        var valueBefore = BitOps.rotl(this.values[iBefore], shiftNow);
        // Copy `shift` bits from the value before into the value at index
        this.values[i] = (value & mainMask) | (valueBefore & rollOverMask);
      }

      on this.values[this.values.domain.last] {
        var mainMask = this._createMainMask(shiftNow);
        var rollOverMask = this._createShiftRolloverMask(shiftNow);
        this.values[this.values.domain.last] = (lastValue & mainMask) | (firstValue & rollOverMask);
      }
    }

    pragma "no doc"
    proc _rotateRightNBits(shiftNow : integral) {
      var firstValue : uint(32);
      var lastValue : uint(32);
      on this.values[this.values.domain.last] {
        firstValue = BitOps.rotr(this.values[this.values.domain.first], shiftNow);
        lastValue = BitOps.rotr(this.values[this.values.domain.last], shiftNow);
      }

      var D = this.values.domain[this.values.domain.first + 1..];
      var DBefore = this.values.domain[..this.values.domain.last - 1];
      forall (i, iBefore) in zip(D, DBefore) {
        var mainMask = this._createMainMask(shiftNow);
        var rollOverMask = this._createShiftRolloverMask(shiftNow);

        // Rotate the value by `shift` bits
        var value = BitOps.rotr(this.values[i], shiftNow);
        var valueBefore = BitOps.rotr(this.values[iBefore], shiftNow);
        // Copy `shift` bits from the value before into the value at index
        this.values[i] = (value & mainMask) | (valueBefore & rollOverMask);
      }

      on this.values[this.values.domain.last] {
        var mainMask = this._createMainMask(shiftNow);
        var rollOverMask = this._createShiftRolloverMask(shiftNow);
        this.values[this.values.domain.last] = (lastValue & mainMask) | (firstValue & rollOverMask);
      }
    }

    /* Rotate all the values to the left. Let values falling out on one side reappear on the left side.

       :arg shift: number of bits to rotate
    */
    proc rotateLeft(shift : integral) {
      if shift > 0 && shift % packSize == 0 {
        this._rotateLeftWholeBlock();
        this.rotateLeft(shift - packSize);
      } else if shift > 0 {
        var shiftNow = shift % packSize;
        this._rotateLeftNBits(shiftNow);
        this.rotateLeft(shift - shiftNow);
      }
    }

    pragma "no doc"
    proc _rotateRightWholeBlock(shift : integral) {
      var firstValue : uint(32);
      on this.values[this.values.domain.last] do
        firstValue = this.values[this.values.domain.first];
      var D = this.values.domain[..this.values.domain.last - 1];
      var DAfter = this.values.domain[this.values.domain.first..];
      // Copy the value value into the value at index
      forall (i, j) in zip(D, DAfter) with (var aggregator = new SrcAggregator(uint(32))) do
        aggregator.copy(this.values[i], this.values[j]);

      // Copy the last value into the first value
      on this.values[this.values.domain.last] do
        this.values[this.values.domain.last] = firstValue;
    }

    pragma "no doc"
    proc _bitshiftRight32Bits() {
      var destination : [this.values.domain] uint(32);
      var DExceptLast = this.values.domain[..this.values.last - 1];
      forall i in DExceptLast with (var aggregator = new SrcAggregator(uint(32))) {
        aggregator.copy(destination[i], this.values[i+1]);
        aggregator.flush();
        aggregator.copy(this.values[i], destination[i]);
      }
      this.values[this.values.last] = 0;
    }

    pragma "no doc"
    proc _bitshiftRightNBits(shift : integral) {
      assert(shift >= 0 && shift < packSize);
      // TODO: rewrite this
      var mainMask = this._createMainMask(shift);
      var rollOverMask = this._createShiftRolloverMask(shift);

      var lastValue = this.values[this.values.domain.first];

      var D = this.values.domain[this.values.domain.first + 1..];
      var DBefore = this.values.domain[..this.values.domain.last - 1];
      // Copy the value value into the value at index
      forall (i, iBefore) in zip(D, DBefore) with (var aggregator = new SrcAggregator(uint(32))) {
        aggregator.copy(this.values[i], ((this.values[i] << shift) & mainMask) | ((this.values[iBefore] << shift) & rollOverMask));
      }

      on Locales[this.values.domain.first] do
        this.values[this.values.domain.first] = ((this.values[this.values.domain.first] << shift) & mainMask) | ((lastValue << shift) & rollOverMask);
    }

    /* Rotate all the values to the right. Let values falling out on one side reappear on the right side.

       :arg shift: number of bits to rotate
    */
    proc rotateRight(shift : integral) {
      if shift > 0 && shift % packSize == 0 {
        this._rotateRightWholeBlock(shift);
        this.rotateRight(shift - packSize);
      } else if shift > 0 {
        var shiftNow = shift % packSize;
        this._rotateRightNBits(shiftNow);
        this.rotateRight(shift - shiftNow);
      }
    }



    /* Set the value at a given index.

       :arg idx: The index of the value to mutate.
       :arg value: The value to set at `idx`.

       :throws BitRangeError: if the idx value is outside the range [0, size).
     */
    proc set(idx : bit32Index, value : bool) throws {
      if idx >= this.size() then
        throw new BitRangeError();
      unsignedSet(packSize, this.values, idx, value);
    }

    /* Get the number of values.

       :returns: bit vector size.
       :rtype: bit32Index
     */
    inline proc size() : bit32Index {
      return this.bitSize;
    }

    /* Iterate over all the values.

       :yields: All the values
       :yields type: bool
     */
    iter these() {
      const mask32 = [
        0b00000000000000000000000000000001 : uint(32),
        0b00000000000000000000000000000010 : uint(32),
        0b00000000000000000000000000000100 : uint(32),
        0b00000000000000000000000000001000 : uint(32),
        0b00000000000000000000000000010000 : uint(32),
        0b00000000000000000000000000100000 : uint(32),
        0b00000000000000000000000001000000 : uint(32),
        0b00000000000000000000000010000000 : uint(32),
        0b00000000000000000000000100000000 : uint(32),
        0b00000000000000000000001000000000 : uint(32),
        0b00000000000000000000010000000000 : uint(32),
        0b00000000000000000000100000000000 : uint(32),
        0b00000000000000000001000000000000 : uint(32),
        0b00000000000000000010000000000000 : uint(32),
        0b00000000000000000100000000000000 : uint(32),
        0b00000000000000001000000000000000 : uint(32),
        0b00000000000000010000000000000000 : uint(32),
        0b00000000000000100000000000000000 : uint(32),
        0b00000000000001000000000000000000 : uint(32),
        0b00000000000010000000000000000000 : uint(32),
        0b00000000000100000000000000000000 : uint(32),
        0b00000000001000000000000000000000 : uint(32),
        0b00000000010000000000000000000000 : uint(32),
        0b00000000100000000000000000000000 : uint(32),
        0b00000001000000000000000000000000 : uint(32),
        0b00000010000000000000000000000000 : uint(32),
        0b00000100000000000000000000000000 : uint(32),
        0b00001000000000000000000000000000 : uint(32),
        0b00010000000000000000000000000000 : uint(32),
        0b00100000000000000000000000000000 : uint(32),
        0b01000000000000000000000000000000 : uint(32),
        0b10000000000000000000000000000000 : uint(32)
      ];

      const packSizeMinusOne = packSize - 1;
      if this.hasRemaining {
        var last = this.values.domain.last;
        var lastMinusOne = last - 1;
        if lastMinusOne >= 0 {
          var wholeBlocksDomain : subdomain(this.values.domain) = this.values.domain[..lastMinusOne];
          for i in wholeBlocksDomain do
            foreach j in {0..packSizeMinusOne} do
              yield this.values[i] & mask32[j] != 0;
        }
        var lastBlock = this.values[last];
        var reminderSize = this.bitSize % packSize - 1;
        foreach j in {0..reminderSize} do
          yield lastBlock & mask32[j] != 0;
      } else {
        for block in this.values do
          foreach j in {0..packSizeMinusOne} do
            yield block & mask32[j] != 0;
      }
    }

    /* Set all the values to `false`.
     */
    proc unfill() {
      this.values = 0;
    }

    /* Compares parwise the values of the two bit arrays for equality.

       :arg lhs: left hand bit array
       :arg rhs: right hand bit array

       :returns: if the bits in the arrays are equal
       :rtype: `list`
     */
    operator ==(lhs : BitArray32, rhs : BitArray32) {
      return lhs.values == rhs.values;
    }

    /*  Compares parwise the values of the two bit arrays for inequality

       :returns: if the bits in the arrays are equal
       :rtype: `list`
     */
    operator !=(lhs : BitArray32, rhs : BitArray32) {
      return lhs.values != rhs.values;
    }

    /* Copies the values from an rhs bit array.

       :arg lhs: the operator to assign
       :arg rhs: The bit array to copy
    */
    operator =(ref lhs : BitArray32, rhs : BitArray32) {
      var D = lhs.values.domain;
      var values : [D] uint(32);
      forall i in rhs.values.domain do
        values[i] = rhs.values[i];

      lhs.bitDomain = rhs.bitDomain;
      lhs.bitSize = rhs.bitSize;
      lhs.hasRemaining = rhs.hasRemaining;
      lhs.values = values;
    }

    /* Nagation operator. Turn all `true` values into `false` values. Turn all `false` values into `true` values.

      :returns: The results
      :rtype: `BitArray32`
    */
    operator !(arg : BitArray32) : BitArray32 {
      var values = ~arg.values;
      var size = arg.size();
      on values[values.domain.last] do
        values[values.domain.last] &= _createReminderMaskFromSizeAndReminder(size, arg.hasRemaining);
      return new BitArray32(values, size);
    }

    /* Shift the values `shift` values to the right. Missing right values are padded with `false` values.

       :arg shift: the number of values to shift.

       :returns: A copy of the values shifted `shift` positions to the right.
       :rtype: `BitArray32`
     */
    operator <<(lhs : BitArray32, shift : integral) : BitArray32 {
      var values = reshape(lhs.values, lhs.values.domain);
      var bitArray : BitArray32 = new BitArray32(values, lhs.size());
      bitArray <<= shift;
      return bitArray;
    }

    /* Shift all the values to the right. Left values are padded with `false` values.

       :arg shift: the number of values to shift.
     */
    operator <<=(ref lhs : BitArray32, shift : integral) {
      lhs._bitshiftLeft(shift);
    }

    /* Shift the values `shift` positions to the left. Missing left values are padded with `false` values.

       :arg shift: the number of values to shift.

       :returns: a copy of the values shifted `shift` positions to the left.
       :rtype: `BitArray32`
     */
    operator >>(shift : integral) : BitArray32 {
      var bitArray : BitArray32 = this;
      bitArray >>= shift;
      return bitArray;
    }

    /* Shift all the values to the right. Left values are padded with `false` values.

       :arg shift: the number of values to shift.
     */
    operator >>=(shift : integral) {
      this._bitshiftRight(shift);
    }

    /* Perform xor the values with the corresponding values in the input bit array. X[i] ^ Y[i] is performed for all indices i where X and Y are bit arrays.
       If one of the two bit arrays has different size then indices fitting the shortes bit array are compared.

       :arg lhs: this bit array
       :arg rhs: bit array to perform xor with
       :returns: The results
       :rtype: `BitArray32`
     */
    operator ^(lhs : BitArray32, rhs : BitArray32) {
      var values = lhs.values ^ rhs.values;
      var size = if lhs.size() < rhs.size() then lhs.size() else rhs.size();
      var hasRemaining = (size % packSize) != 0;
      on values[values.domain.last] do
        values[values.domain.last] &= _createReminderMaskFromSizeAndReminder(size, hasRemaining);
      return new BitArray32(values, size);
    }

    /* Perform xor the values with the corresponding values in the input bit array. X[i] ^ Y[i] is performed for all indices i where X and Y are bit arrays.
       If one of the two bit arrays has different size then indices fitting the shortes bit array are compared.

       :arg lhs: this bit array
       :arg rhs: bit array to perform xor with
     */
    operator ^=(ref lhs : BitArray32, rhs : BitArray32) {
      lhs.values ^= rhs.values;
      on lhs.values[lhs.values.domain.last] do
        lhs.values[lhs.values.domain.last] &= lhs._createReminderMask();
    }

    /* Perform the and operation on the values in this bit array with the values in another bit array.
       If one of the two bit arrays has different size then indices fitting the shortes bit array are compared.

       :arg lhs: this bit array
       :arg rhs: bit array to perform and with

       :returns: the result of `lhs` or `rhs`
       :rtype: `BitArray32`
     */
    operator &(lhs : BitArray32, rhs : BitArray32) : BitArray32 {
      var values = lhs.values & rhs.values;
      var size = if lhs.size() < rhs.size() then lhs.size() else rhs.size();
      return new BitArray32(values, size);
    }

    /* Perform the and operation on the values in this bit array with the values in another bit array.
       If one of the two bit arrays has different size then indices fitting the shortes bit array are compared.

       :arg lhs: this bit array
       :arg rhs: bit array to perform and with
     */
    operator &=(ref lhs : BitArray32, rhs : BitArray32) : BitArray32 {
      lhs.values &= rhs.values;
    }

    /* Perform the or operation on the values in this bit array with the values in another bit array.

       :arg lhs: this bit array
       :arg rhs: bit array to perform or with

       :returns: The result of `lhs` or `rhs`
       :rtype: `BitArray32`
     */
    operator |(lhs : BitArray32, rhs : BitArray32) : BitArray32 {
      var values = lhs.values | rhs.values;
      var size = if lhs.size() < rhs.size() then lhs.size() else rhs.size();
      return new BitArray32(values, size);
    }

    /* Perform the or operation on the values in this bit array with the values in another bit array.

      :arg lhs: this bit array
      :arg rhs: bit array to perform or with
    */
    operator |=(ref lhs : BitArray32, rhs : BitArray32) {
      lhs.values |= rhs.values;
    }
  }
}