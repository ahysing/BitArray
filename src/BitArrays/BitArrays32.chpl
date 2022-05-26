module BitArrays32 {
  use AllLocalesBarriers;
  use BitOps;
  use BlockDist;
  use super.Internal;

  pragma "no doc"
  const allOnes : uint(32) = 0b11111111111111111111111111111111;

  pragma "no doc"
  const one : uint(32) = 1;

  pragma "no doc"
  const packSize : uint(32) = 32;

/* Exception thrown when indexing the bit arrays outside the range of values the bit array */
  class Bit32RangeError : IllegalArgumentError {
    proc init() {
      super.init("idx is out of range");
    }
  }
  /* BitArray32 is an array of boolean values stored packed together as 32 bit words. All boolean values are mapped one-to-one to a bit value in memory. */
  class BitArray32 {
    pragma "no doc"
    var bitDomain : domain(rank=1, idxType=uint(32), stridable=false);

    pragma "no doc"
    var bitSize : uint(32);

    pragma "no doc"
    var hasRemaining : bool;

    pragma "no doc"
    var values : [bitDomain] uint(32) = noinit;

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
    proc _reverseWord(value : uint(32)) {
      return reverse32(value);
    }

    pragma "no doc"
    proc _bitshift(shift : uint) {
      if shift < packSize && shift > 0 {
        var mask = one << (shift + 1) - 1;
        var topMask = ~mask;
        var lastValue = this.values[0] & mask;

        forall i in this.values.domain do {
          var temp = this.values[i - 1] & mask;
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
        this._bitshift(packSize);
        shift -= packSize;
        this._bitshift(shift);
      }
    }

    pragma "no doc"
    proc _bitshiftReverse(shift : uint) {
      if shift < packSize && shift > 0 {
        var mask = one >> (shift + 1) - 1;
        var topMask = ~mask;
        var lastValue = this.values[0] & mask;

        forall i in this.values.domain do {
          var temp = this.values[i - 1] & mask;
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
        this._bitshiftReverse(packSize);
        this._bitshiftReverse(shift - packSize);
      }
    }

    pragma "no doc"
    proc _createReminderMask() {
      if this.hasRemaining then
        return (1 << (this.bitSize % packSize)) : uint(32) - one;
      else
        return allOnes;
    }

    /* Tests all the values with and.

       :returns: `true` if all the values are true
       :rtype: boolean value
     */
    proc all() : bool {
      return all(this.hasRemaining, this.values);
    }

    /* Tests all the values with or.

      :returns: `true` if any of the values are true
      :rtype: bool
    */
    proc any() : bool {
      var result = true;
      forall i in this.values.domain do
        result &= this.values[i] != 0;
      return result;
    }


    /* Looks up value at `idx`.

       :arg idx: The index in the bitarray to look up.

       :returns: value at `idx`
       :rtype: bool

       :throws Bit32RangeError: If `idx` is outside the range [1..size).
    */
    proc at(idx : uint(32)) : bool throws {
      if idx >= this.size() then
        throw new Bit32RangeError();

      var pageIdx = idx / packSize;
      pageIdx += this.values.domain.first;
      var block : uint(32) = this.values[pageIdx];
      var mask = one << (idx % packSize);
      var bit = block & mask;
      return bit != 0;
    }

    /* Compares two bit arrays by values.

       :returns: `true` if the two bit arrays has identical values.
     */
    proc equals(rhs : borrowed BitArray32) {
      return this.values.equals(rhs.values);
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

    /* Rotate all the values to the right. Let values falling out on one side reappear on the rhs side.
    */
    proc rotr(shift) {
    }

    /* Reverse the ordering of the values. The last value becomes the first value. The second last value becomes the second first value. And so on.
     */
    proc reverse() {
      this.values.reverse();
      forall i in this.values.domain do
        this.values[i] = this._reverseWord(this.values[i]);

      if this.hasRemaining then
        this._bitshift(this.bitSize % packSize);
    }

    /* Rotate all the values to the left. Let values falling out on one side reappear on the rhs side.

       :arg shift: number of bits to rotate
    */
    proc rotateLeft(shift : uint) {
      if shift != 0 {
        var mainMask = ((1 << shift) - 1) : uint(32);
        var reminderMask = allOnes - mainMask;

        var firstValue = this.values[this.values.domain.first];
        var first = BitOps.rotl(firstValue, shift);
        var D = this.values.domain[this.values.domain.first + 1..];
        var DBefore = this.values.domain[..this.values.domain.last - 1];
        forall (i, j) in zip(D, DBefore) do {
          this.values[i] = BitOps.rotl(this.values[i], shift);
          allLocalesBarrier.barrier();
          var reminder = this.values[j];
          var value = this.values[i];
          value &= mainMask;
          value |= reminder & reminderMask;
          this.values[i] |= value;
        }
      }
    }

    /* Set the value at a given index.

       :arg idx: The index of the value to mutate.
       :arg value: The value to set at `idx`.

       :throws Bit32RangeError: if the idx value is outside the range [0, size).
     */
    proc set(idx : uint(32), value : bool) throws {
      if idx >= this.size() then
        throw new Bit32RangeError();

      var pageIdx = idx / packSize;
      var block = this.values[pageIdx];
      var rem : uint(32) = (idx % packSize);
      var mask : uint(32) = one << rem : uint(32);
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
    operator <<=(shift : uint) {
      this._bitshift(shift);
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
    operator >>=(shift : uint) {
      this._bitshiftReverse(shift);
    }

    /* Perform xor the values with the corresponding values in the input bit array. X[i] ^ Y[i] is performed for all indices i where X and Y are bit arrays.
       If one of the two bit arrays has different size then indices fitting the shortes bit array are compared.

       :rhs: bit array to perform xor with
     */
    operator ^=(lhs : borrowed BitArray32, rhs : borrowed BitArray32) {
      lhs.values = lhs.values ^ rhs.values;
      if this.hasRemaining then
        lhs.values[lhs.values.domain.last] &= this._createReminderMask();
    }

    /* Perform the and operation on the values in this bit array with the values in another bit array.
       If one of the two bit arrays has different size then indices fitting the shortes bit array are compared.

       :rhs: bit array to perform and with
     */
    operator &(lhs : borrowed BitArray32, rhs : borrowed BitArray32) {
      lhs.values = lhs.values & rhs.values;
      if this.hasRemaining then
        lhs.values[lhs.values.domain.last] &= this._createReminderMask();
    }

    /* Perform the or operation on the values in this bit array with the values in another bit array.

       :rhs: bit array to perform or with
     */
    operator |(lhs : borrowed BitArray32, rhs : borrowed BitArray32) {
      lhs.values = lhs.values || rhs.values;
      if this.hasRemaining then
        lhs.values[lhs.values.domain.last] &= this._createReminderMask();
    }
  }
}