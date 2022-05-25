module BitArrays32 {
  use BitOps;
  use AllLocalesBarriers;
  use BlockDist;

  pragma "no doc"
  const packSize : uint(32) = 32;

  pragma "no doc"
  const pack : uint(32);

  pragma "no doc"
  const allOnes : uint(32) = 0b11111111111111111111111111111111;

  pragma "no doc"
  const one : uint(32) = 1;

  /* Exception thrown when indexing the bit arrays outside the range of values the bit array */
  class ArrayRangeError : IllegalArgumentError {
    proc init() {
      super.init("idx is out of range");
    }
  }

  /* BitArray32 is an array of boolean values stored packed together as 32 bit words. All boolean values are mapped one to one with a bit value in memory. */
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
      var sizeAsInt : uint(32) = this._getNumberOfBlocks(hasRemaining, size);
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
    proc _getNumberOfBlocks(hasRemaining : bool, size : uint(32)) {
      var sizeAsInt : uint(32) = (size / packSize);
      if hasRemaining then
        sizeAsInt = sizeAsInt + 1;
      return sizeAsInt;
    }

    pragma "no doc"
    const eightBitReversed : [0..255]uint(32) = [
        0x00: uint(32), 0x80: uint(32), 0x40: uint(32), 0xC0: uint(32), 0x20: uint(32), 0xA0: uint(32), 0x60: uint(32), 0xE0: uint(32), 0x10: uint(32), 0x90: uint(32), 0x50: uint(32), 0xD0: uint(32), 0x30: uint(32), 0xB0: uint(32), 0x70: uint(32), 0xF0: uint(32),
        0x08: uint(32), 0x88: uint(32), 0x48: uint(32), 0xC8: uint(32), 0x28: uint(32), 0xA8: uint(32), 0x68: uint(32), 0xE8: uint(32), 0x18: uint(32), 0x98: uint(32), 0x58: uint(32), 0xD8: uint(32), 0x38: uint(32), 0xB8: uint(32), 0x78: uint(32), 0xF8: uint(32),
        0x04: uint(32), 0x84: uint(32), 0x44: uint(32), 0xC4: uint(32), 0x24: uint(32), 0xA4: uint(32), 0x64: uint(32), 0xE4: uint(32), 0x14: uint(32), 0x94: uint(32), 0x54: uint(32), 0xD4: uint(32), 0x34: uint(32), 0xB4: uint(32), 0x74: uint(32), 0xF4: uint(32),
        0x0C: uint(32), 0x8C: uint(32), 0x4C: uint(32), 0xCC: uint(32), 0x2C: uint(32), 0xAC: uint(32), 0x6C: uint(32), 0xEC: uint(32), 0x1C: uint(32), 0x9C: uint(32), 0x5C: uint(32), 0xDC: uint(32), 0x3C: uint(32), 0xBC: uint(32), 0x7C: uint(32), 0xFC: uint(32),
        0x02: uint(32), 0x82: uint(32), 0x42: uint(32), 0xC2: uint(32), 0x22: uint(32), 0xA2: uint(32), 0x62: uint(32), 0xE2: uint(32), 0x12: uint(32), 0x92: uint(32), 0x52: uint(32), 0xD2: uint(32), 0x32: uint(32), 0xB2: uint(32), 0x72: uint(32), 0xF2: uint(32),
        0x0A: uint(32), 0x8A: uint(32), 0x4A: uint(32), 0xCA: uint(32), 0x2A: uint(32), 0xAA: uint(32), 0x6A: uint(32), 0xEA: uint(32), 0x1A: uint(32), 0x9A: uint(32), 0x5A: uint(32), 0xDA: uint(32), 0x3A: uint(32), 0xBA: uint(32), 0x7A: uint(32), 0xFA: uint(32),
        0x06: uint(32), 0x86: uint(32), 0x46: uint(32), 0xC6: uint(32), 0x26: uint(32), 0xA6: uint(32), 0x66: uint(32), 0xE6: uint(32), 0x16: uint(32), 0x96: uint(32), 0x56: uint(32), 0xD6: uint(32), 0x36: uint(32), 0xB6: uint(32), 0x76: uint(32), 0xF6: uint(32),
        0x0E: uint(32), 0x8E: uint(32), 0x4E: uint(32), 0xCE: uint(32), 0x2E: uint(32), 0xAE: uint(32), 0x6E: uint(32), 0xEE: uint(32), 0x1E: uint(32), 0x9E: uint(32), 0x5E: uint(32), 0xDE: uint(32), 0x3E: uint(32), 0xBE: uint(32), 0x7E: uint(32), 0xFE: uint(32),
        0x01: uint(32), 0x81: uint(32), 0x41: uint(32), 0xC1: uint(32), 0x21: uint(32), 0xA1: uint(32), 0x61: uint(32), 0xE1: uint(32), 0x11: uint(32), 0x91: uint(32), 0x51: uint(32), 0xD1: uint(32), 0x31: uint(32), 0xB1: uint(32), 0x71: uint(32), 0xF1: uint(32),
        0x09: uint(32), 0x89: uint(32), 0x49: uint(32), 0xC9: uint(32), 0x29: uint(32), 0xA9: uint(32), 0x69: uint(32), 0xE9: uint(32), 0x19: uint(32), 0x99: uint(32), 0x59: uint(32), 0xD9: uint(32), 0x39: uint(32), 0xB9: uint(32), 0x79: uint(32), 0xF9: uint(32),
        0x05: uint(32), 0x85: uint(32), 0x45: uint(32), 0xC5: uint(32), 0x25: uint(32), 0xA5: uint(32), 0x65: uint(32), 0xE5: uint(32), 0x15: uint(32), 0x95: uint(32), 0x55: uint(32), 0xD5: uint(32), 0x35: uint(32), 0xB5: uint(32), 0x75: uint(32), 0xF5: uint(32),
        0x0D: uint(32), 0x8D: uint(32), 0x4D: uint(32), 0xCD: uint(32), 0x2D: uint(32), 0xAD: uint(32), 0x6D: uint(32), 0xED: uint(32), 0x1D: uint(32), 0x9D: uint(32), 0x5D: uint(32), 0xDD: uint(32), 0x3D: uint(32), 0xBD: uint(32), 0x7D: uint(32), 0xFD: uint(32),
        0x03: uint(32), 0x83: uint(32), 0x43: uint(32), 0xC3: uint(32), 0x23: uint(32), 0xA3: uint(32), 0x63: uint(32), 0xE3: uint(32), 0x13: uint(32), 0x93: uint(32), 0x53: uint(32), 0xD3: uint(32), 0x33: uint(32), 0xB3: uint(32), 0x73: uint(32), 0xF3: uint(32),
        0x0B: uint(32), 0x8B: uint(32), 0x4B: uint(32), 0xCB: uint(32), 0x2B: uint(32), 0xAB: uint(32), 0x6B: uint(32), 0xEB: uint(32), 0x1B: uint(32), 0x9B: uint(32), 0x5B: uint(32), 0xDB: uint(32), 0x3B: uint(32), 0xBB: uint(32), 0x7B: uint(32), 0xFB: uint(32),
        0x07: uint(32), 0x87: uint(32), 0x47: uint(32), 0xC7: uint(32), 0x27: uint(32), 0xA7: uint(32), 0x67: uint(32), 0xE7: uint(32), 0x17: uint(32), 0x97: uint(32), 0x57: uint(32), 0xD7: uint(32), 0x37: uint(32), 0xB7: uint(32), 0x77: uint(32), 0xF7: uint(32),
        0x0F: uint(32), 0x8F: uint(32), 0x4F: uint(32), 0xCF: uint(32), 0x2F: uint(32), 0xAF: uint(32), 0x6F: uint(32), 0xEF: uint(32), 0x1F: uint(32), 0x9F: uint(32), 0x5F: uint(32), 0xDF: uint(32), 0x3F: uint(32), 0xBF: uint(32), 0x7F: uint(32), 0xFF: uint(32)
    ];

    pragma "no doc"
    inline proc _reverse32(value : uint(32)) {
      var result : uint(32) = 0;
      var idx : uint(32);

      idx = value & 0xff;
      result = (eightBitReversed[idx]) << 24;

      idx = (value >> 8) & 0xff;
      result |= (eightBitReversed[idx]) << 16;

      idx = (value >> 16) & 0xff;
      result |= (eightBitReversed[idx]) << 8;

      idx = (value >> 24) & 0xff;
      result |= (eightBitReversed[idx]);

      return result;
    }

    pragma "no doc"
    inline proc _reverse16(value :uint(16)) {
      var result : uint(16) = 0;
      var idx : uint(32);

      idx = value & 0xff;
      result = (eightBitReversed[idx]) << 8;

      idx = (value >> 8) & 0xff;
      result |= (eightBitReversed[idx]);

      return result;
    }

    pragma "no doc"
    inline proc _reverse8(value :uint(8)) {
      return eightBitReversed[value] : uint(8);
    }

    pragma "no doc"
    proc _reverse(value : uint(32)) {
      return this._reverse32(value);
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
        return (1 << (this.bitSize % packSize)) : pack.type - one;
      else
        return allOnes;
    }

    /* Tests all the values with and.

       :returns: `true` if all the values are true
       :rtype: boolean value
     */
    proc all() : bool {
      if this.hasRemaining then {
        var last = this.values.domain.dim(1) - 1;
        var dom : subdomain(this.values.domain) = this.values.domain[..last];

        var result = true;
        foreach i in dom do
          result &= BitOps.popcount(this.values[i]) == packSize;

        var lastValues = this.values[this.values.domain.laset()];
        result &= (lastValues == this._createReminderMask());
        return result;
      } else {
        var result = true;
        foreach i in this.values.domain do
          result &= BitOps.popcount(this.values[i]) == packSize;
        return result;
      }
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

       :throws ArrayRangeError: If `idx` is outside the range [1..size).

       :return: value at `idx`
       :rtype: bool
    */
    proc at(idx : uint(32)) : bool throws {
      if idx >= this.size() then
        throw new ArrayRangeError();

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
    proc popcount() {
      var count : atomic uint(32) = 0;
      for i in this.values.domain do
        count.add(BitOps.popcount(this.values[i]));
      return count.read();
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
        this.values[i] = this._reverse(this.values[i]);

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

       :throws ArrayRangeError: if the idx value is outside the range [0, size).
     */
    proc set(idx : uint(32), value : bool) throws {
      if idx >= this.size() then
        throw new ArrayRangeError();

      var pageIdx = idx / packSize;
      var block : uint(32) = this.values[pageIdx];
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

       :returns: All the values. yelds one value at a time
       :rtype: bool
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
        var lastMinusOne = last - 2;
        var wholeBlocksDomain : subdomain(this.values.domain) = this.values.domain[..lastMinusOne];
        for i in wholeBlocksDomain do
          foreach j in {0..packSizeMinusOne} do
            yield this.values[i] & mask32[j] != 0;

        var lastBlock = this.values[last];
        var reminderSize = this.bitSize % packSize;
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

    /*
       :arg shift: the number of values to shift.
     */
    operator <<(shift : uint) {
    }

    /* Shift all the values to the right. Left values are padded with false values.

       :arg shift: the number of values to shift.
     */
    operator <<=(shift : uint) {
      this._bitshift(shift);
    }

    /* Shift all the values to the right. Left values are padded with false values.

       :arg shift: the number of values to shift.
     */
    operator >>(shift : uint) {
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

    /* Perform the and operation on the values in this bit array with the values in anrhs bit array.
       If one of the two bit arrays has different size then indices fitting the shortes bit array are compared.

       :rhs: bit array to perform and with
     */
    operator &(lhs : borrowed BitArray32, rhs : borrowed BitArray32) {
      lhs.values = lhs.values & rhs.values;
      if this.hasRemaining then
        lhs.values[lhs.values.domain.last] &= this._createReminderMask();
    }

    /* Perform the or operation on the values in this bit array with the values in anrhs bit array.

       :rhs: bit array to perform or with
     */
    operator |(lhs : borrowed BitArray32, rhs : borrowed BitArray32) {
      lhs.values = lhs.values || rhs.values;
      if this.hasRemaining then
        lhs.values[lhs.values.domain.last] &= this._createReminderMask();
    }
  }
}