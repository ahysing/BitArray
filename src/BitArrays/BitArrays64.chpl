module BitArrays64 {
  use AllLocalesBarriers;
  use BitOps;
  use BlockDist;
  use super.Internal;
  use super.Errors;

  type bit64Index = int;

  pragma "no doc"
  const allOnes : uint(64) = 0b1111111111111111111111111111111111111111111111111111111111111111;

  pragma "no doc"
  const one : uint(64) = 1;

  pragma "no doc"
  const packSize : bit64Index = 64;

  /* BitArray64 is an array of boolean values stored packed together as 64 bit words. All boolean values are mapped one-to-one to a bit value in memory. */
  class BitArray64 {
    pragma "no doc"
    var bitDomain : domain(rank=1, idxType=bit64Index, stridable=false);

    pragma "no doc"
    var bitSize : bit64Index;

    pragma "no doc"
    var hasRemaining : bool;

    pragma "no doc"
    var values : [bitDomain] uint(64) = noinit;

    /* Create a bit array of a given size.

       :arg size: The size of the bit array
       :arg locales: What nodes to distibute the values over
     */
    proc init(size : bit64Index, locales=Locales) {
      this.complete();
      var hasRemaining = (size % packSize) != 0;
      var sizeAsInt : bit64Index = getNumberOfBlocks(hasRemaining, packSize, size);
      var lastIdx = sizeAsInt - 1;
      var Space = {0..lastIdx};
      var bitDomain : domain(rank=1, idxType=bit64Index, stridable=false) dmapped Block(boundingBox=Space) = Space;
      var values : [bitDomain] uint(64);
      this.bitDomain = bitDomain;
      this.bitSize = size;
      this.hasRemaining = hasRemaining;
      this.values = values;
    }


    /* Create a bit array from a given set of values. The input values are used directly in the bit array. Values are not copied into this BitArray64 instance.

       :arg values: The bit array packed as 64 bit integers.
       :arg size: How many vlaues there are
     */
    proc init(values : [] uint(64), size : bit64Index) {
      this.complete();
      // Compare sizes from blocks of 64 bits and given size.
      // Make sure the the number of bits in a block fits size or size + 1
      assert(findNumberOfBlocks(values) / 2 == (size / packSize) / 2);
      var hasRemaining = (size % packSize) != 0;
      this.bitDomain = values.domain;
      this.bitSize = size;
      this.hasRemaining = hasRemaining;
      this.values = values;
    }

    pragma "no doc"
    proc _createReminderMask() {
      if this.hasRemaining then
        return (1 << (this.bitSize % packSize)) : uint(64) - one;
      else
        return allOnes;
    }

    pragma "no doc"
    proc _reverseWord(value : uint(32)) {
      return reverse64(value);
    }

    /* Test if any of the values are true

      :returns: `true` if any of the values are true
      :rtype: `bool`
    */
    proc any() : bool {
      unsignedAny(this.values);
    }

    /* Test if all the values are true

      :returns: `true` if any of the values are true
      :rtype: `bool`
    */
    proc all() : bool {
      return unsignedAll(this.values, packSize, this.size());
    }

    /* Looks up value at `idx`.

       :arg idx: The index in the bitarray to look up.

       :throws BitRangeError: If `idx` is outside the range [1..size).

       :return: value at `idx`
       :rtype: `bool`
    */
    proc at(idx : bit64Index) : bool throws {
      if idx >= this.size() then
        throw new BitRangeError();
      return unsignedAt(packSize, this.values, idx);
    }

    /* Set all the values to `true`.
     */
    proc fill() {
      for i in this.values.domain do
        this.values[i] = allOnes;
      this.values[this.values.domain.last] &= this._createReminderMask();
    }

    /* Count the number of values set to true.

       :returns: The count
       :rtype: `int`
     */
    proc popcount() : bit64Index {
      return _popcount(values);
    }

    /* Set the value at a given index.

       :arg idx: The index of the value to mutate.
       :arg value: The value to set at `idx`.

       :throws BitRangeError: if the idx value is outside the range [0, size).
     */
    proc set(idx : bit64Index, value : bool) throws {
      if idx >= this.size() then
        throw new BitRangeError();
      unsignedSet(packSize, this.values, idx, value);
    }

    /* Get the number of values.

       :returns: bit vector size.
       :rtype: int(64)
     */
    inline proc size() {
      return this.bitSize;
    }

    /* Iterate over all the values.

       :yields: All the values
       :yields type: bool
     */
    iter these() {
      const packSizeMinusOne = packSize - 1;
      if this.hasRemaining {
        var last = this.values.domain.last;
        var lastMinusOne = last - 1;
        var wholeBlocksDomain : subdomain(this.values.domain) = this.values.domain[..lastMinusOne];
        for i in wholeBlocksDomain do
          foreach j in {0..packSizeMinusOne} do
            yield this.values[i] & (one << j) != 0;

        var lastBlock = this.values[last];
        var reminderSize = this.bitSize % packSize - 1;
        foreach j in {0..reminderSize} do
          yield lastBlock & (one << j) != 0;
      } else {
        for block in this.values do
          foreach j in {0..packSizeMinusOne} do
            yield block & (one << j) != 0;
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
    operator ==(lhs : BitArray64, rhs : BitArray64) {
      return lhs.values == rhs.values;
    }

    /*  Compares parwise the values of the two bit arrays for inequality

       :arg lhs: left hand bit array
       :arg rhs: right hand bit array

       :returns: if the bits in the arrays are equal
       :rtype: `BitArray64`
     */
    operator !=(lhs : BitArray64, rhs : BitArray64) {
      return new BitArray64(lhs.values != rhs.values);
    }

    /* Copies the values from an rhs bit array.

       :arg lhs: the left hand bit array to assign
       :arg rhs: The right hand array to copy
    */
    operator =(ref lhs : BitArray64, rhs : BitArray64) {
      var D = lhs.values.domain;
      var values : [D] uint(32);
      forall i in rhs.values.domain do
        values[i] = rhs.values[i];

      lhs.bitDomain = rhs.bitDomain;
      lhs.bitSize = rhs.bitSize;
      lhs.hasRemaining = rhs.hasRemaining;
      lhs.values = values;
    }

    /* Perform xor the values with the corresponding values in the input bit array. X[i] ^ Y[i] is performed for all indices i where X and Y are bit arrays.
       If one of the two bit arrays has different size then indices fitting the shortes bit array are compared.

       :arg lhs: this bit array
       :arg rhs: bit array to perform xor with

       :returns: The results
       :rtype: `BitArray64`
     */
    operator ^(lhs : BitArray64, rhs : BitArray64) {
      var values = lhs.values ^ rhs.values;
      var size = if lhs.size() < rhs.size() then lhs.size() else rhs.size();
      var hasRemaining = (size % packSize) != 0;
      on values[values.domain.last] do
        values[values.domain.last] &= _createReminderMaskFromSizeAndReminder(size, hasRemaining);
      return new BitArray64(values, size);
    }

    /* Perform xor the values with the corresponding values in the input bit array. X[i] ^ Y[i] is performed for all indices i where X and Y are bit arrays.
       If one of the two bit arrays has different size then indices fitting the shortes bit array are compared.

       :arg lhs: this bit array
       :arg rhs: bit array to perform xor with
     */
    operator ^=(ref lhs : BitArray64, rhs : BitArray64) {
      lhs.values ^= rhs.values;
      on lhs.values[lhs.values.domain.last] do
        lhs.values[lhs.values.domain.last] &= lhs._createReminderMask();
    }

    /* Perform the and operation on the values in this bit array with the values in another bit array.
       If one of the two bit arrays has different size then indices fitting the shortes bit array are compared.

       :arg lhs: this bit array
       :arg rhs: bit array to perform and with

       :returns: the results
       :rtype: `BitArray64`
     */
    operator &(lhs : BitArray64, rhs : BitArray64) : BitArray64 {
      var values = lhs.values & rhs.values;
      var size = if lhs.size() < rhs.size() then lhs.size() else rhs.size();
      return new BitArray64(values, size);
    }

    /* Perform the and operation on the values in this bit array with the values in another bit array.
       `lhs` is updated with the result of the operation.

       :arg lhs: this bit array
       :arg rhs: bit array to perform and with
     */
    operator &=(ref lhs : BitArray64, rhs : BitArray64) : BitArray64 {
      lhs.values &= rhs.values;
    }

    /* Perform the or operation on the values in this bit array with the values in another bit array.

       :arg lhs: this bit array
       :arg rhs: bit array to perform or with

       :returns: A copy of the values from `lhs` or `rhs`
       :rtype: BitArray32
     */
    operator |(lhs : BitArray64, rhs : BitArray64) : BitArray64 {
      var values = lhs.values | rhs.values;
      var size = if lhs.size() < rhs.size() then lhs.size() else rhs.size();
      return new BitArray64(values, size);
    }

    /* Perform the or operation on the values in this bit array with the values in another bit array.
       `lhs` is updated with the result of the operation.

      :arg lhs: this bit array
      :arg rhs: bit array to perform or with
    */
    operator |=(ref lhs : BitArray64, rhs : BitArray64) {
      lhs.values |= rhs.values;
    }
  }
}