module BitArrays64 {
  use AllLocalesBarriers;
  use BitOps;
  use BlockDist;
  use super.Internal;

  pragma "no doc"
  const allOnes : uint(64) = 0b1111111111111111111111111111111111111111111111111111111111111111;

  pragma "no doc"
  const one : uint(64) = 1;

  pragma "no doc"
  const packSize : uint(32) = 64;

/* Exception thrown when indexing the bit arrays outside the range of values the bit array */
  class Bit64RangeError : IllegalArgumentError {
    proc init() {
      super.init("idx is out of range");
    }
  }
  /* BitArray64 is an array of boolean values stored packed together as 64 bit words. All boolean values are mapped one-to-one to a bit value in memory. */
  class BitArray64 {
    pragma "no doc"
    var bitDomain : domain(rank=1, idxType=uint(32), stridable=false);

    pragma "no doc"
    var bitSize : uint(32);

    pragma "no doc"
    var hasRemaining : bool;

    pragma "no doc"
    var values : [bitDomain] uint(64) = noinit;

    /* Create a bit array of a given size.

       :arg size: The size of the bit array
       :arg locales: What nodes to distibute the values over
     */
    proc init(size : uint(32), locales=Locales) {
      this.complete();
      var hasRemaining = (size % packSize) != 0;
      var sizeAsInt : uint(32) = getNumberOfBlocks(hasRemaining, packSize, size);
      var lastIdx = sizeAsInt - 1;
      var Space = {0..lastIdx};
      var bitDomain : domain(rank=1, idxType=uint(32), stridable=false) dmapped Block(boundingBox=Space) = Space;
      var values : [bitDomain] uint(32);
      this.bitDomain = bitDomain;
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

    /* Looks up value at `idx`.

       :arg idx: The index in the bitarray to look up.

       :throws Bit64RangeError: If `idx` is outside the range [1..size).

       :return: value at `idx`
       :rtype: bool
    */
    proc at(idx : uint(32)) : bool throws {
      if idx >= this.size() then
        throw new Bit64RangeError();

      var pageIdx = idx / packSize;
      pageIdx += this.values.domain.first;
      var block : uint(64) = this.values[pageIdx];
      var mask = one << (idx % packSize);
      var bit = block & mask;
      return bit != 0;
    }

    /* Set all the values to `true`.
     */
    proc fill() {
      for i in this.values.domain do
        this.values[i] = allOnes;
      var reminderMask = this._createReminderMask();
      this.values[this.values.domain.last] = this.values[this.values.domain.last] & reminderMask;
    }

    /* Count the number of values set to true.

       :returns: The count.
     */
    proc popcount() : uint(32) {
      return _popcount(values);
    }

    /* Set the value at a given index.

       :arg idx: The index of the value to mutate.
       :arg value: The value to set at `idx`.

       :throws Bit64RangeError: if the idx value is outside the range [0, size).
     */
    proc set(idx : uint(32), value : bool) throws {
      if idx >= this.size() then
        throw new Bit64RangeError();

      var pageIdx = idx / packSize;
      var block = this.values[pageIdx];
      var rem : uint(64) = (idx % packSize);
      var mask : uint(64) = one << rem;
      if value && (block & mask) == 0 then
        this.values[pageIdx] = block | mask;
      else if !value && (block & mask) != 0 then
        this.values[pageIdx] = block ^ mask;
    }

    /* Get the number of values.

       :returns: bit vector size.
       :rtype: uint(32)
     */
    proc size() {
      return this.bitSize;
    }

    /* Set all the values to `false`.
     */
    proc unfill() {
      this.values = 0;
    }



    /* Perform xor the values with the corresponding values in the input bit array. X[i] ^ Y[i] is performed for all indices i where X and Y are bit arrays.
       If one of the two bit arrays has different size then indices fitting the shortes bit array are compared.

       :rhs: bit array to perform xor with
     */
    operator ^=(lhs : borrowed BitArray64, rhs : borrowed BitArray64) {
      lhs.values = lhs.values ^ rhs.values;
      if this.hasRemaining then
        lhs.values[lhs.values.domain.last] &= this._createReminderMask();
    }

    /* Perform the and operation on the values in this bit array with the values in another bit array.
       If one of the two bit arrays has different size then indices fitting the shortes bit array are compared.

       :rhs: bit array to perform and with
     */
    operator &(lhs : borrowed BitArray64, rhs : borrowed BitArray64) {
      lhs.values = lhs.values & rhs.values;
      if this.hasRemaining then
        lhs.values[lhs.values.domain.last] &= this._createReminderMask();
    }

    /* Perform the or operation on the values in this bit array with the values in another bit array.

       :rhs: bit array to perform or with
     */
    operator |(lhs : borrowed BitArray64, rhs : borrowed BitArray64) {
      lhs.values = lhs.values || rhs.values;
      if this.hasRemaining then
        lhs.values[lhs.values.domain.last] &= this._createReminderMask();
    }
  }
}