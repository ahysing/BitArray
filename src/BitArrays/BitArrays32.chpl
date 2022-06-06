module BitArrays32 {
  use AllLocalesBarriers;
  use BitOps;
  use BlockDist;
  use super.Internal;
  use CopyAggregation;

  type bit32Index = int;

  pragma "no doc"
  const allOnes : uint(32) = 0b11111111111111111111111111111111;

  pragma "no doc"
  const one : uint(32) = 1;

  pragma "no doc"
  const packSize : bit32Index = 32;

  /* Exception thrown when indexing the bit arrays outside the range of values the bit array */
  class Bit32RangeError : IllegalArgumentError {
    proc init() {
      super.init("idx is out of range");
    }
  }

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

    /* Create a bit array from a given set of values. The input values are used directly in the bit array. Values are not copied into the class BitArray32 instance.

       :arg values: The bit array.
     */
    proc init(values : [] uint(32), size : bit32Index) {
      this.complete();
      // Compare sizes from blocks of 32 bits and given size.
      // Make sure the the number of bits in a block fits size or size + 1
      assert(findNumberOfBlocks(values) / 2 == (size / packSize) / 2);
      var hasRemaining = (size % packSize) != 0;
      this.bitDomain = values.domain;
      this.bitSize = size;
      this.hasRemaining = hasRemaining;
      this.values = values;
    }

    pragma "no doc"
    proc _bitshiftLeftNBits(shift : bit32Index) {
      var mainMask = this._createMainMask(shift);
      var rollOverMask = this._createShiftRolloverMask(shift);

      var lastValue = this.values[this.values.domain.first];

      var D = this.values.domain[this.values.domain.first + 1..];
      var DBefore = this.values.domain[..this.values.domain.last - 1];
      // Copy the value value into the value at index
      forall (i, iBefore) in zip(D, DBefore) with (var aggregator = new SrcAggregator(uint(32))) {
        aggregator.copy(this.values[i], ((this.values[i] << shift) & mainMask) | ((this.values[iBefore] << shift) & rollOverMask));
      }

      on Locales[this.values.domain.first] {
        this.values[this.values.domain.first] = ((this.values[this.values.domain.first] << shift) & mainMask) | ((lastValue << shift) & rollOverMask);
      }
    }

    pragma "no doc"
    proc _bitshiftLeft(shift : bit32Index) {
      if shift % packSize == 0 && shift > 0 {
        this._bitshiftLeft32Bits();
        var nextShift = shift - packSize;
        this._bitshiftLeft(nextShift);
      } else if shift > 0 {
        this._bitshiftLeftNBits(shift);
        var nextShift = shift - packSize;
        this._bitshiftLeft(nextShift);
      }
    }

    pragma "no doc"
    proc _bitshiftRight(shift : uint) {
      if shift < packSize && shift > 0 {
        var mask = one >> (shift + 1) - 1;
        var topMask = ~mask;
        var lastValue = this.values[0] & mask;

        forall i in this.values.domain do {
          var rollOverValues = (this.values[i - 1] & topMask);
          this.values[i] = this.values[i] & rollOverValues;
        }

        this.values[this.values.domain - 1] = lastValue;
      } else if shift == packSize {
        var lastValue : int = this.values[0];

        forall i in this.values.domain do
          this.values[i] = this.values[i - 1];

        this.values[this.values.domain.last] = lastValue;
      } else if shift > 0 {
        this._bitshiftRight(packSize);
        this._bitshiftRight(shift - packSize);
      }
    }

    pragma "no doc"
    proc _createMainMask(shift : int) : uint(32) {
      return ((1 << shift) - 1) : uint(32);
    }

    pragma "no doc"
    proc _createReminderMask() : uint(32) {
      return _createReminderMaskFromSizeAndReminder(this.bitSize, this.hasRemaining);
    }

    pragma "no doc"
    proc _createShiftRolloverMask(shift : int) : uint(32) {
      const one = 1 : uint(32);
      return allOnes - ((one << shift) - 1) : uint(32);
    }

    pragma "no doc"
    inline proc _reverseWord(value : uint(32)) {
      return reverse32(value);
    }

    /* Tests all the values with and.

       :returns: `true` if all the values are true
       :rtype: boolean value
     */
    proc all() : bool {
      return unsignedAll(this.hasRemaining, packSize, this.size(), this.values);
    }

    /* Tests all the values with or.

      :returns: `true` if any of the values are true
      :rtype: bool
    */
    proc any() : bool {
      return unsignedAny(this.values);
    }


    /* Looks up value at `idx`.

       :arg idx: The index in the bitarray to look up.

       :returns: value at `idx`
       :rtype: bool

       :throws Bit32RangeError: If `idx` is outside the range [1..size).
    */
    proc at(idx : bit32Index) : bool throws {
      if idx >= this.size() then
        throw new Bit32RangeError();
      return unsignedAt(packSize, this.values, idx);
    }

    /* Compares two bit arrays by values.

       :returns: `true` if the two bit arrays has identical values.
       :rtype: bool
     */
    proc equals(rhs : borrowed BitArray32) : bool {
      return this.values.equals(rhs.values);
    }

    /* Set all the values to `true`.
     */
    proc fill() {
      this.values = allOnes;
      on this.values[this.values.domain.last] do
        this.values[this.values.domain.last] &= this._createReminderMask();
    }

    /* Count the number of values set to true.

       :returns: The count.
       :rtype: uint(32)
     */
    proc popcount() : uint(32) {
      return _popcount(values);
    }

    /* Reverse the ordering of the values. The last value becomes the first value. The second last value becomes the second first value. And so on.
     */
    proc reverse() {
      this.values.reverse();
      forall i in this.values.domain do
        this.values[i] = this._reverseWord(this.values[i]);

      if this.hasRemaining {
        var shift = this.bitSize % packSize;
        this._bitshiftLeft(shift);
      }
    }

    pragma "no doc"
    proc _bitshiftLeft32Bits() {
        var firstValue = this.values[this.values.domain.first];

        var sub = this.values.domain[this.values.first + 1..];
        forall i in sub with (var aggregator = new SrcAggregator(uint(32))) do
          aggregator.copy(this.values[i], this.values[i + 1]);

        this.values[this.values.domain.last] = firstValue;
    }

    pragma "no doc"
    proc _rotateLeft32Bits(shift : int) {
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
    proc _rotateLeftNBits(shiftNow : int) {
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
    proc _rotateRightNBits(shiftNow : int) {
      var firstValue : uint(32);
      var lastValue : uint(32);
      on this.values[this.values.domain.last] {
        firstValue = BitOps.rotl(this.values[this.values.domain.first], shiftNow);
        lastValue = BitOps.rotl(this.values[this.values.domain.last], shiftNow);
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

    /* Rotate all the values to the left. Let values falling out on one side reappear on the rhs side.
       Uses https://chapel-lang.org/docs/modules/packages/CopyAggregation.html

       :arg shift: number of bits to rotate
    */
    proc rotateLeft(shift : int) {
      if shift > 0 && shift % packSize == 0 {
        this._rotateLeft32Bits(shift);
        this.rotateLeft((shift : bit32Index) - packSize);
      } else if shift > 0 {
        var shiftNow = shift % packSize;
        this._rotateLeftNBits(shiftNow);
        this.rotateLeft((shiftNow : bit32Index) - packSize);
      }
    }






    pragma "no doc"
    proc _rotateRight32Bits(shift : int) {
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
        var firstValue = this.values[this.values.domain.first];

        var sub = this.values.domain[..this.values.last - 1];
        forall i in sub with (var aggregator = new SrcAggregator(uint(32))) do
          this.values[i] = this.values[i - 1];

        this.values[this.values.domain.last] = firstValue;
    }

    /* Rotate all the values to the right. Let values falling out on one side reappear on the rhs side.
       Uses https://chapel-lang.org/docs/modules/packages/CopyAggregation.html

       :arg shift: number of bits to rotate
    */
    proc rotateRight(shift : int) {
      if shift > 0 && shift % packSize == 0 {
        this._rotateRight32Bits(shift);
        this.rotateRight((shift : bit32Index) - packSize);
      } else if shift > 0 {
        var shiftNow = shift % packSize;
        this._rotateRightNBits(shiftNow);
        this.rotateRight((shiftNow : bit32Index) - packSize);
      }
    }



    /* Set the value at a given index.

       :arg idx: The index of the value to mutate.
       :arg value: The value to set at `idx`.

       :throws Bit32RangeError: if the idx value is outside the range [0, size).
     */
    proc set(idx : bit32Index, value : bool) throws {
      if idx >= this.size() then
        throw new Bit32RangeError();
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
        var wholeBlocksDomain : subdomain(this.values.domain) = this.values.domain[..lastMinusOne];
        for i in wholeBlocksDomain do
          foreach j in {0..packSizeMinusOne} do
            yield this.values[i] & mask32[j] != 0;

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

    /* Compares two bit arrays by values with corresponding indices. All the values are set according to X[i] == Y[i] where X and Y are the to bit arrays to compare.

       :returns: The result values
       :rtype: BitArray32
     */
    operator ==(lhs : borrowed BitArray32, rhs : borrowed BitArray32) {
      var bitarray = new BitArray32(lhs.size());
      bitarray.values = lhs.values ^ ~rhs.values;
      return bitarray;
    }

    /* Compares two bit arrays by values with corresponding indices. All the values are set according to X[i] != Y[i] where X and Y are the to bit arrays to compare.

       :returns: The result values
       :rtype: BitArray32
     */
    operator !=(lhs : borrowed BitArray32, rhs : borrowed BitArray32) {
      var bitarray = new BitArray32(lhs.size());
      bitarray.values = lhs.values ^ rhs.values;
      return bitarray;
    }

    /* Copies the values from an rhs bit array.
       :arg lhs: the operator to assign
       :arg rhs: The bit array to copy
    */
    operator =(ref lhs : BitArray32, rhs : borrowed BitArray32) {
      var D = lhs.values.domain;
      var values : [D] uint(32);
      forall i in rhs.values.domain do
        values[i] = rhs.values[i];

      lhs.bitDomain = rhs.bitDomain;
      lhs.bitSize = rhs.bitSize;
      lhs.hasRemaining = rhs.hasRemaining;
      lhs.values = values;
    }

    /* Negate the values.
    */
    operator ~(arg : borrowed BitArray32) {
      arg.values = ~arg.values;
      arg.values[arg.values.domain.last] &= this._createReminderMask();
    }

    /* Shift the values `shift` values to the right. Missing right values are padded with `false` values.

       :arg shift: the number of values to shift.

       :returns: A copy of the values shifted `shift` positions to the right.
       :rtype: BitArray32
     */
    operator <<(shift : uint) : BitArray32 {
      var bitArray : BitArray32 = this;
      bitArray <<= shift;
      return bitArray;
    }

    /* Shift all the values to the right. Left values are padded with false values.

       :arg shift: the number of values to shift.
     */
    operator <<=(shift : bit32Index) {
      this._bitshiftLeft(shift);
    }

    /* Shift the values `shift` positions to the left. Missing left values are padded with `false` values.

       :arg shift: the number of values to shift.

       :returns: a copy of the values shifted `shift` positions to the left.
       :rtype: BitArray32
     */
    operator >>(shift : uint) : BitArray32 {
      var bitArray : BitArray32 = this;
      bitArray >>= shift;
      return bitArray;
    }

    /* Shift all the values to the right. Left values are padded with false values.

       :arg shift: the number of values to shift.
     */
    operator >>=(shift : bit32Index) {
      this._bitshiftRight(shift);
    }

    /* Perform xor the values with the corresponding values in the input bit array. X[i] ^ Y[i] is performed for all indices i where X and Y are bit arrays.
       If one of the two bit arrays has different size then indices fitting the shortes bit array are compared.

       :arg lhs: this bit array
       :arg rhs: bit array to perform xor with
     */
    operator ^=(lhs : borrowed BitArray32, rhs : borrowed BitArray32) {
      lhs.values = lhs.values ^ rhs.values;
      if this.hasRemaining then
        lhs.values[lhs.values.domain.last] &= this._createReminderMask();
    }

    /* Perform the and operation on the values in this bit array with the values in another bit array.
       If one of the two bit arrays has different size then indices fitting the shortes bit array are compared.

       :lhs: this bit array
       :rhs: bit array to perform and with

       :returns: the results
       :rtype: BitArray32
     */
    operator &(lhs : BitArray32, rhs : BitArray32) : BitArray32 {
      var values = lhs.values & rhs.values;
      var size = if lhs.size() < rhs.size() then lhs.size() else rhs.size();
      var hasRemaining = (size % packSize) != 0;
      values[values.domain.last] &= _createReminderMaskFromSizeAndReminder(size, hasRemaining);
      return new BitArray32(values, size);
    }

    /* Perform the and operation on the values in this bit array with the values in another bit array.
       If one of the two bit arrays has different size then indices fitting the shortes bit array are compared.

       :lhs: this bit array
       :rhs: bit array to perform and with
     */
    operator &=(ref lhs : BitArray32, rhs : BitArray32) : BitArray32 {
      lhs.values &= rhs.values;
      lhs.values[lhs.values.domain.last] &= lhs._createReminderMask();
    }

    /* Perform the or operation on the values in this bit array with the values in another bit array.

       :lhs: this bit array
       :rhs: bit array to perform or with
     */
    operator |(lhs : BitArray32, rhs : BitArray32) : BitArray32 {
      var values = lhs.values | rhs.values;
      var size = if lhs.size() < rhs.size() then lhs.size() else rhs.size();
      var hasRemaining = (size % packSize) != 0;
      values[values.domain.last] &= _createReminderMaskFromSizeAndReminder(size, hasRemaining);
      return new BitArray32(values, size);
    }

    /* Perform the or operation on the values in this bit array with the values in another bit array.

      :lhs: this bit array
      :rhs: bit array to perform or with
    */
    operator |=(ref lhs : BitArray32, rhs : BitArray32) {
      lhs.values |= rhs.values;
      lhs.values[lhs.values.domain.last] &= lhs._createReminderMask();
    }
  }
}