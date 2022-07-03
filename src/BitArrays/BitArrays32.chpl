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

  /* BitArray32 is an array of boolean values stored packed together as 32 bit words. All boolean values are mapped one-to-one to a bit in a 32 bit integer. */
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
       The values are distributed across locales with a `Block` distribution.

       :arg size: The size of the bit array
       :arg locales: What nodes to distibute the values over
     */
    proc init(size : bit32Index, targetLocales=Locales) {
      this.complete();
      var hasRemaining = size % packSize != 0;
      var sizeAsInt : bit32Index = getNumberOfBlocks(hasRemaining, packSize, size);
      var lastIdx = sizeAsInt - 1;
      var Space = {0..lastIdx};
      var bitDomain : domain(rank=1, idxType=bit32Index, stridable=false) dmapped Block(boundingBox=Space, targetLocales=targetLocales) = Space;
      var values : [bitDomain] uint(32);

      assert(!values.isAssociative());
      assert(!values.isSparse());
      assert(values.isRectangular());

      this.bitDomain = bitDomain;
      this.bitSize = size;
      this.hasRemaining = hasRemaining;
      this.values = values;
    }

    /* Create a bit array from a given set of values.
       * The input values must be a rectangular 1-dimensional array.
       * The input values must not be a sparse array.
       * The input values must not be an associative array.

       :arg values: The valuess in the bit array stored as 32 bit integers.  If the size does is not a multiple of 32 then one extra value must be added to contain the reminder bits.
       :arg size: The number of individual bits in the bit array.
     */
    proc init(ref values : [] uint(32), size : bit32Index) {
      this.complete();
      if (values.isAssociative()) {
        halt("ref values is associative");
      }

      if (values.isSparse()) {
        halt("ref values is sparse");
      }

      if (!values.isRectangular()) {
        halt("ref values is not rectangular");
      }

      // Compare sizes from blocks of 32 bits and given size.
      // Make sure the the number of bits in a block fits size or size + 1
      if (findNumberOfBlocks(values) != (size + (packSize - 1)) / packSize) {
        halt("Make sure the number of bits 32 bit blocks * size or 32 bit blocks * size plus one block. (#blocks, size): (", findNumberOfBlocks(values), ", ", size, ")");
      }

      var hasRemaining = (size % packSize) != 0;
      this.bitDomain = values.domain;
      this.bitSize = size;
      this.hasRemaining = hasRemaining;
      this.values = reshape(values, values.domain);
    }

    pragma "no doc"
    proc _bitshiftLeftNBits(shift : integral) {
      assert(shift > 0 && shift < packSize);

      var D = this.values.domain;
      var DExceptFirst = {(D.first + 1)..(D.last)};
      // var destination : [D] this.values.eltType;
      var reverseShift = packSize - shift;
      for i in DExceptFirst by -1 do
        this.values[i] = (this.values[i] << shift) | (this.values[i - 1] >> reverseShift);
      this.values[D.first] = (this.values[D.first] << shift);
      // for i in D do
      //  this.values[i] = destination[i];
    }

    pragma "no doc"
    proc _bitshiftLeft(shift : integral) {
      if (!this.values.isEmpty()) {
        if shift > 0 && shift % packSize == 0 {
          this._bitshiftLeftWholeBlock();
          var nextShift = shift - packSize;
          this._bitshiftLeft(nextShift);
        } else if shift > 0 {
          var shiftNow = shift % packSize;
          this._bitshiftLeftNBits(shiftNow);
          var nextShift = shift - shiftNow;
          this._bitshiftLeft(nextShift);
        }
      }
    }

    pragma "no doc"
    proc _bitshiftRight(shift : integral) {
      if (!this.values.isEmpty()) {
        if shift > 0 && shift % packSize == 0 {
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
    }

    pragma "no doc"
    proc _createMainMaskToLeft(shift : integral) : uint(32) {
      const one = 1 : uint(32);
      return allOnes - ((one << shift:int(32)) - 1) : uint(32);
    }

    pragma "no doc"
    proc _createMainMaskRight(shift : integral) : uint(32) {
      var x = packSize - shift;
      return ((1 << x) - 1) : uint(32);
    }

    pragma "no doc"
    proc _createShiftRolloverMask(shift : integral) : uint(32) {
      return ((1 << shift) - 1) : uint(32);
    }

    pragma "no doc"
    proc _createShiftRolloverMaskRight(shift : integral) : uint(32) {
      return _createShiftRolloverMask(packSize - shift);
    }

    pragma "no doc"
    proc _createReminderMask() : uint(32) {
      return _createReminderMaskFromSizeAndReminder(this.bitSize, this.hasRemaining);
    }

    /* Test if all the values are `true`.

       :returns: `true` if all the values are `true`
       :rtype: `bool`
     */
    proc all() : bool {
      return unsignedAll(this.values, packSize, this.size());
    }

    /* Test if any of the values are true

      :returns: `true` if any of the values are `true`
      :rtype: `bool`
    */
    proc any() : bool {
      return unsignedAny(this.values);
    }


    /* Look up value at index `idx`.

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
    proc popcount() {
      return _popcount(values);
    }

    /* Reverse the ordering of the values. The last value becomes the first value. The second last value becomes the second first value. And so on.
     */
    proc reverse() {
      this.values.reverse();
      forall i in this.values.domain do
        this.values[i] = reverse32(this.values[i]);

      if this.hasRemaining then
        this._bitshiftRightNBits(packSize - (this.bitSize % packSize));
    }

    pragma "no doc"
    proc _generalBitshiftLeftWholeBlockSerial(ref values : [], D : domain) {
      var DExceptLast = {(D.first)..(D.last - 1)};
      for i in DExceptLast by -1 {
        values[i + 1] = values[i];
      }
      values[D.first] = 0;
    }

    pragma "no doc"
    proc _bitshiftLeftWholeBlockSerial() {
      this._generalBitshiftLeftWholeBlockSerial(this.values, this.values.domain);
    }

//     pragma "no doc"
//     proc _bitshiftLeftWholeBlockParallell() {
//       var D = this.values.domain;
//       var localesSize = this.values.targetLocales().size;
//       var F : domain(2) = {1..localesSize, 0..countSubdomains(values)};
//       var storedValue : [F] this.values.eltType;
//       for loc in D.targetLocales() {
//         var i = 0;
//         for sub in D.localSubdomains(loc) {
//           /* TODO
//           /Users/andreas.dreyer.hysing/code/BitArray/src/BitArrays/BitArrays32.chpl:254: error: halt reached - array index out of bounds
//           note: index was (0, 0) but array bounds are (1..1, 0..1)
//           note: out of bounds in dimension 0 because index 0 is not in 1..1
//           BitArray32Tests was compiled with optimization - stepping may behave oddly; variables may not be available.
//           */
//           storedValue[(loc.id, i)] = if D.contains(sub.first - 1) then this.values[sub.first - 1] else 0 : this.values.eltType;
//           i += 1;
//         }
//       }
//
//       // example got from https://chapel-lang.org/docs/users-guide/locality/onClauses.html
//       coforall loc in D.targetLocales() do
//         on loc do
//           for sub in D.localSubdomains(loc) do
//             this._generalBitshiftLeftWholeBlockSerial(this.values, sub);
//
//       for loc in D.targetLocales() {
//         var i = 0;
//         for sub in D.localSubdomains(loc) {
//           this.values[sub.first] = storedValue[(loc.id, i)];
//           i += 1;
//         }
//       }
//     }

    pragma "no doc"
    proc _bitshiftLeftWholeBlock() {
      this._bitshiftLeftWholeBlockSerial();
    }

    pragma "no doc"
    proc _rotateRightWholeBlock() {
      var D = this.values.domain;
      var DExceptLast = {(D.first)..(D.last - 1)};
      for i in DExceptLast {
        var temp = this.values[i + 1];
        this.values[i + 1] = this.values[i];
        this.values[i] = temp;
      }
    }

    pragma "no doc"
    proc _rotateLeftNBits(shift : integral) {
      assert(shift > 0 && shift < packSize);

      var D = this.values.domain;
      var DExceptFirst = {(D.first + 1)..(D.last)};

      var reverseShift = packSize - shift;
      var lastValue = this.values[D.last] >> reverseShift;

      forall i in DExceptFirst do
        this.values[i] = BitOps.rotl(this.values[i], shift);

      var mainMask = this._createMainMaskToLeft(shift);
      var rollOverMask = this._createShiftRolloverMask(shift);
      for i in DExceptFirst by -1 do
        this.values[i] = (this.values[i] & mainMask) | (this.values[i - 1] & rollOverMask);
      this.values[D.first] = (this.values[D.first] << shift) | lastValue;
    }
    /*
    var DExceptLast = {(D.first)..(D.last - 1)};
      for i in DExceptLast {
        var temp = this.values[i + 1];
        this.values[i + 1] = this.values[i];
        this.values[i] = temp;
      }
      */
    pragma "no doc"
    proc _rotateRightNBits(shift : integral) {
      assert(shift > 0 && shift < packSize);

      var D = this.values.domain;
      var DExceptLast = {(D.first)..(D.last - 1)};

      var reverseShift = packSize - shift;
      var firstValue = this.values[D.first] << reverseShift;

      forall i in DExceptLast do
        this.values[i] = BitOps.rotr(this.values[i], shift);

      var mainMask = this._createMainMaskRight(shift);
      var rollOverMask = this._createShiftRolloverMaskRight(shift);
      for i in DExceptLast do
        this.values[i] = (this.values[i] & mainMask) | (this.values[i + 1] & rollOverMask);
      this.values[D.last] = (this.values[D.last] >> shift) | firstValue;
    }

    /* Rotate all the values to the left. Values wrap around to the other side.

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
    proc _rotateLeftWholeBlock() {
      var D = this.values.domain;
      var DExceptLast = {(D.first)..(D.last - 1)};
      var last = this.values[D.last];
      for i in DExceptLast by -1 {
        this.values[i + 1] = this.values[i];
      }
      this.values[D.first] = last;
    }

    pragma "no doc"
    proc _bitshiftRight32Bits() {
      var D = this.values.domain;

      var DExceptEdges : sparse subdomain(D) = D[(D.first)..(D.last - 1)];
      var destination : [D] this.values.eltType;

      for i in DExceptEdges do
        destination[i] = this.values[i + 1];
      destination[D.first] = this.values[D.first + 1]; //TODOs

      this.values[D.last] = 0;
      for i in DExceptEdges do
        this.values[i] = destination[i];
    }

    pragma "no doc"
    proc _bitshiftRightNBits(shift : integral) {
      assert(shift > 0 && shift < packSize);

      var D = this.values.domain;
      var DExceptLast = {(D.first)..(D.last - 1)};
      // Copy the value value into the value at index
      // var destination : [D] this.values.eltType;
      var reverseShift = packSize - shift;
      for i in DExceptLast do
        this.values[i] = (this.values[i] >> shift) | (this.values[i + 1] << reverseShift);
      this.values[D.last] = (this.values[D.last] >> shift);
      // forall i in D do
      //  this.values[i] = destination[i];
    }

    /* Rotate all the values to the right. Values wrap around to the other side.

       :arg shift: number of bits to rotate
    */
    proc rotateRight(shift : integral) {
      if shift > 0 && shift % packSize == 0 {
        this._rotateRightWholeBlock();
        this.rotateRight(shift - packSize);
      } else if shift > 0 {
        var shiftNow = shift % packSize;
        this._rotateRightNBits(shiftNow);
        this.rotateRight(shift - shiftNow);
      }
    }



    /* Set the value at a given index.

       :arg idx: The index of the value.
       :arg value: The value to set.

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
      var D = this.values.domain;
      const packSizeMinusOne = packSize - 1;
      if this.hasRemaining {
        var lastMinusOne = D.last - 1;
        if lastMinusOne >= 0 {
          var wholeBlocksDomain : subdomain(D) = {D.first..lastMinusOne};
          for i in wholeBlocksDomain do
            foreach j in {0..packSizeMinusOne} do
              yield this.values[i] & 1 << j != 0;
        }

        var reminderSize = this.size() % packSize - 1;
        foreach j in {0..reminderSize} do
          yield this.values[D.last] & 1 << j != 0;
      } else {
        for block in this.values do
          foreach j in {0..packSizeMinusOne} do
            yield block & 1 << j != 0;
      }
    }

    /* Iterate  over the index of all the values that are `true`.

      :yields: The index of a `true` value
      :yields type: `int`
    */
    iter trueIndicies() {
      for i in this.values.domain {
        var block = this.values[i];
        while block != 0 {
          var czt = BitOps.ctz(block);
          yield (i * packSize) + czt;
          block ^= 1 << czt;
        }
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

       :arg lhs: left hand bit array
       :arg rhs: right hand bit array

       :returns: if the bits in the arrays are equal
       :rtype: `list`
     */
    operator !=(lhs : BitArray32, rhs : BitArray32) {
      return lhs.values != rhs.values;
    }

    /* Copies the values from a bit array.

       :arg lhs: the bit array to assign
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

      :returns: A copy of this bit array negated.
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

      :returns: A copy of the values shifted to the right.
      :rtype: `BitArray32`

      :throws ShiftRangeError: If `shift` is less than zero or bigger than the size of the bit array.
     */
    operator <<(lhs : BitArray32, shift : integral) : BitArray32 throws {
      if shift > lhs.size() || shift < 0 then
        throw new ShiftRangeError();

      var values = reshape(lhs.values, lhs.values.domain);
      var bitArray : BitArray32 = new BitArray32(values, lhs.size());
      bitArray <<= shift;
      return bitArray;
    }

    /* Shift all the values to the right. Left values are padded with `false` values.

      :arg shift: the number of values to shift.

      :throws ShiftRangeError: If `shift` is less than zero or bigger than the size of the bit array.
     */
    operator <<=(ref lhs : BitArray32, shift : integral) throws {
      if shift > lhs.size() || shift < 0 then
        throw new ShiftRangeError();

      lhs._bitshiftLeft(shift);
    }

    /* Shift the values `shift` positions to the left. Missing left values are padded with `false` values.

       :arg shift: the number of values to shift.

       :returns: a copy of the values shifted `shift` positions to the left.
       :rtype: `BitArray32`

       :throws ShiftRangeError: If `shift` is less than zero or bigger than the size of the bit array.
     */
    operator >>(lhs : BitArray32, shift : integral) : BitArray32 throws {
      if shift > lhs.size() || shift < 0 then
        throw new ShiftRangeError();

      var bitArray : BitArray32 = this;
      bitArray >>= shift;
      return bitArray;
    }

    /* Shift all the values to the right. Left values are padded with `false` values.

       :arg shift: the number of values to shift.

       :throws ShiftRangeError: If `shift` is less than zero or bigger than the size of the bit array.
     */
    operator >>=(shift : integral) throws {
      if shift > this.size() || shift < 0 then
        throw new ShiftRangeError();

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
      if lhs.size() >= lhs.size() {
        lhs.values ^= rhs.values;
        on lhs.values[lhs.values.domain.last] do
          lhs.values[lhs.values.domain.last] &= lhs._createReminderMask();
      } else {
        var first = rhs.values.domain.first;
        var last = rhs.values.domain.last;
        foreach (i, j) in zip(lhs.values.domain[first..last], rhs.values.domain) do
          lhs.values = lhs.values[i] ^ rhs.values[j];

        var lasti = first;
        foreach (i, j) in zip(lhs.values.domain, rhs.values.domain) do
          lasti = i;
        on lhs.values[lasti] do
          lhs.values[lasti] &= lhs._createReminderMask();
      }
    }

    /* Perform the and operation on the values in this bit array with the values in another bit array.
       If one of the two bit arrays has different size then indices fitting the shortes bit array are compared.

       :arg lhs: this bit array
       :arg rhs: bit array to perform and with

       :returns: the result of `lhs` or `rhs`
       :rtype: `BitArray32`
    */
    operator &(lhs : BitArray32, rhs : BitArray32) : BitArray32 {
      if lhs.size() >= rhs.size() {
        var result = lhs.values & rhs.values;
        return new BitArray32(result, lhs.size());
      } else {
        var values : [lhs.values.domain] lhs.values.eltType;
        var first = rhs.values.domain.first;
        var last = rhs.values.domain.last;
        foreach (i, j) in zip(lhs.values.domain[first..last], rhs.values.domain) do
          values[i] = lhs.values[i] & rhs.values[j];
        return new BitArray32(values, lhs.size());
      }
    }

    /* Perform the and operation on the values in this bit array with the values in another bit array.
       If one of the two bit arrays has different size then indices fitting the shortes bit array are compared.

       :arg lhs: this bit array
       :arg rhs: bit array to perform and with
    */
    operator &=(ref lhs : BitArray32, rhs : BitArray32) : BitArray32 {
      if lhs.size() >= rhs.size() then
        lhs.values &= rhs.values;
      else {
        var first = rhs.values.domain.first;
        var last = rhs.values.domain.last;
        foreach (i, j) in zip(lhs.values.domain[first..last], rhs.values.domain) do
          lhs.values[i] = lhs.values[i] & rhs.values[j];
      }
    }

    /* Perform the or operation on the values in this bit array with the values in another bit array.

       :arg lhs: this bit array
       :arg rhs: bit array to perform or with

       :returns: The result of `lhs` or `rhs`
       :rtype: `BitArray32`
    */
    operator +(lhs : BitArray32, rhs : BitArray32) : BitArray32 {
      var values = lhs.values | rhs.values;
      var size = if lhs.size() < rhs.size() then lhs.size() else rhs.size();
      return new BitArray32(values, size);
    }

    /* Perform the or operation on the values in this bit array with the values in another bit array.

      :arg lhs: this bit array
      :arg rhs: bit array to perform or with
    */
    operator +=(ref lhs : BitArray32, rhs : BitArray32) {
      lhs.values |= rhs.values;
    }

    /* Perform the minus operation on the values in this bit array with the values in another bit array.
       The result is all the values in `lhs` which are not present in `rhs`.

      :arg lhs: this bit array
      :arg rhs: bit array to perform minus with

      :returns: The result of `lhs` - `rhs`
      :rtype: `BitArray32`
    */
    operator -(lhs : BitArray32, rhs : BitArray32) {
      var D = lhs.values.domain;
      var values : [D] lhs.values.eltType = lhs.values & !rhs.values;
      return new BitArray32(values, lhs.size());
    }

    /* Perform the minus operation on the values in this bit array with the values in another bit array.
       The result is all the values in `lhs` which are not present in `rhs`.

      :arg lhs: this bit array
      :arg rhs: bit array to perform minus with
    */
    operator -=(ref lhs : BitArray32, rhs : BitArray32) {
      lhs.values = lhs.values & !rhs.values;
    }
  }
}