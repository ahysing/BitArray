/* BitArray is a library for effective storage of boolean values in arrays. */
module BitArray {
  use BitOps;

  pragma "no doc"
  const packSize : uint(32) = 32;
  pragma "no doc"
  const one : uint(32) = 1;

  /* Exception thrown when indexing the bit arrays outside the range of values the bit array */
  class ArrayRangeError : IllegalArgumentError {
    proc init() {
      super.init("idx is out of range");
    }
  }

  /* BitArray1D is an array of boolean values stored packed together. All boolean values are mapped one to one with a bit value in memory. */
  class BitArray1D {
    pragma "no doc"
    var bitDomain : domain(rank=1, idxType=uint(32), stridable=false);

    pragma "no doc"
    var bitSize : uint(32);

    pragma "no doc"
    var hasRemaining : bool;

    pragma "no doc"
    var values : [bitDomain] uint(32) = noinit;

    /* Create a bit array of a given size.

       :size: The size of the bit array
     */
    proc init(size : uint(32)) {
      this.complete();
      var hasRemaining = (size % packSize) != 0;
      var sizeAsInt : uint(32) = this._getNumberOfBlocks(hasRemaining, size);
      var lastIdx = sizeAsInt - 1;
      var bitDomain : domain(rank=1, idxType=uint(32), stridable=false) = {0..lastIdx};
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
    proc _reverse(value : uint(32)) {
      const eightBitReversed : [0..255] uint(8) = [
        0b00000000,
        0b10000000,
        0b01000000,
        0b11000000,
        0b00100000,
        0b10100000,
        0b01100000,
        0b11100000,
        0b00010000,
        0b10010000,
        0b01010000,
        0b11010000,
        0b00110000,
        0b10110000,
        0b01110000,
        0b11110000,
        0b00001000,
        0b10001000,
        0b01001000,
        0b11001000,
        0b00101000,
        0b10101000,
        0b01101000,
        0b11101000,
        0b00011000,
        0b10011000,
        0b01011000,
        0b11011000,
        0b00111000,
        0b10111000,
        0b01111000,
        0b11111000,
        0b00000100,
        0b10000100,
        0b01000100,
        0b11000100,
        0b00100100,
        0b10100100,
        0b01100100,
        0b11100100,
        0b00010100,
        0b10010100,
        0b01010100,
        0b11010100,
        0b00110100,
        0b10110100,
        0b01110100,
        0b11110100,
        0b00001100,
        0b10001100,
        0b01001100,
        0b11001100,
        0b00101100,
        0b10101100,
        0b01101100,
        0b11101100,
        0b00011100,
        0b10011100,
        0b01011100,
        0b11011100,
        0b00111100,
        0b10111100,
        0b01111100,
        0b11111100,
        0b00000010,
        0b10000010,
        0b01000010,
        0b11000010,
        0b00100010,
        0b10100010,
        0b01100010,
        0b11100010,
        0b00010010,
        0b10010010,
        0b01010010,
        0b11010010,
        0b00110010,
        0b10110010,
        0b01110010,
        0b11110010,
        0b00001010,
        0b10001010,
        0b01001010,
        0b11001010,
        0b00101010,
        0b10101010,
        0b01101010,
        0b11101010,
        0b00011010,
        0b10011010,
        0b01011010,
        0b11011010,
        0b00111010,
        0b10111010,
        0b01111010,
        0b11111010,
        0b00000110,
        0b10000110,
        0b01000110,
        0b11000110,
        0b00100110,
        0b10100110,
        0b01100110,
        0b11100110,
        0b00010110,
        0b10010110,
        0b01010110,
        0b11010110,
        0b00110110,
        0b10110110,
        0b01110110,
        0b11110110,
        0b00001110,
        0b10001110,
        0b01001110,
        0b11001110,
        0b00101110,
        0b10101110,
        0b01101110,
        0b11101110,
        0b00011110,
        0b10011110,
        0b01011110,
        0b11011110,
        0b00111110,
        0b10111110,
        0b01111110,
        0b11111110,
        0b00000001,
        0b10000001,
        0b01000001,
        0b11000001,
        0b00100001,
        0b10100001,
        0b01100001,
        0b11100001,
        0b00010001,
        0b10010001,
        0b01010001,
        0b11010001,
        0b00110001,
        0b10110001,
        0b01110001,
        0b11110001,
        0b00001001,
        0b10001001,
        0b01001001,
        0b11001001,
        0b00101001,
        0b10101001,
        0b01101001,
        0b11101001,
        0b00011001,
        0b10011001,
        0b01011001,
        0b11011001,
        0b00111001,
        0b10111001,
        0b01111001,
        0b11111001,
        0b00000101,
        0b10000101,
        0b01000101,
        0b11000101,
        0b00100101,
        0b10100101,
        0b01100101,
        0b11100101,
        0b00010101,
        0b10010101,
        0b01010101,
        0b11010101,
        0b00110101,
        0b10110101,
        0b01110101,
        0b11110101,
        0b00001101,
        0b10001101,
        0b01001101,
        0b11001101,
        0b00101101,
        0b10101101,
        0b01101101,
        0b11101101,
        0b00011101,
        0b10011101,
        0b01011101,
        0b11011101,
        0b00111101,
        0b10111101,
        0b01111101,
        0b11111101,
        0b00000011,
        0b10000011,
        0b01000011,
        0b11000011,
        0b00100011,
        0b10100011,
        0b01100011,
        0b11100011,
        0b00010011,
        0b10010011,
        0b01010011,
        0b11010011,
        0b00110011,
        0b10110011,
        0b01110011,
        0b11110011,
        0b00001011,
        0b10001011,
        0b01001011,
        0b11001011,
        0b00101011,
        0b10101011,
        0b01101011,
        0b11101011,
        0b00011011,
        0b10011011,
        0b01011011,
        0b11011011,
        0b00111011,
        0b10111011,
        0b01111011,
        0b11111011,
        0b00000111,
        0b10000111,
        0b01000111,
        0b11000111,
        0b00100111,
        0b10100111,
        0b01100111,
        0b11100111,
        0b00010111,
        0b10010111,
        0b01010111,
        0b11010111,
        0b00110111,
        0b10110111,
        0b01110111,
        0b11110111,
        0b00001111,
        0b10001111,
        0b01001111,
        0b11001111,
        0b00101111,
        0b10101111,
        0b01101111,
        0b11101111,
        0b00011111,
        0b10011111,
        0b01011111,
        0b11011111,
        0b00111111,
        0b10111111,
        0b01111111,
        0b11111111,
      ];

      var result : uint(32) = 0;
      var idx : uint(8);
      idx = value;
      result &= (eightBitReversed[idx] : uint(32)) << 24;

      idx = value : uint(8) >> 8;
      result &= (eightBitReversed[idx] : uint(32)) << 16;

      idx = value : uint(8) >> 16;
      result &= (eightBitReversed[idx] : uint(32)) << 8;

      idx = value : uint(8) >> 24;
      result &= (eightBitReversed[idx] : uint(32));

      return result;
    }

    pragma "no doc"
    proc _bitshift(shift : int) {
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
        this._bitshift(shift - packSize);
      }
    }

    pragma "no doc"
    proc _bitshiftReverse(shift : int) {
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
      if this.bitSize % packSize == 0 then
        return 0b11111111111111111111111111111111 : uint(32);
      var result = (1 << (this.bitSize % packSize)) : uint(32);
      return result - one;
    }

    /* Tests all the values.
       Returns true if all the bytes are true.

       :return: boolean value.
     */
    proc all() {
      if this.hasRemaining then {
        var last = this.values.domain.dim(1) - 1;
        var dom : subdomain(this.values.domain);
            dom = this.values.domain[..last];

        var result = true;
        forall i in dom do
          result &= BitOps.popcount(this.values[i]) == packSize;

        var lastValues = this.values[this.values.domain.laset()];
        result &= (lastValues == this._createReminderMask());
        return result;
      } else {
        var result = true;
        forall i in this.values.domain do
          result &= BitOps.popcount(this.values[i]) == packSize;
        return result;
      }
    }

    /* Tests all the bits.
       Result is true if any the values are true.

       :return: boolean value.
     */
    proc any() {
      var result = true;
      forall i in this.values.domain do
        result &= this.values[i] != 0;
      return result;
    }


    /* Looks up bit at `idx`.

       :arg idx: The index in the bitarray to look up.

       :throws ArrayRangeError: If `idx` is outside the range [1..size).

       :return: boolean value.
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

       :returns: true if the two bit arrays has identical values.
     */
    proc equals(rhs : borrowed BitArray1D) {
      return this.values.equals(rhs.values);
    }

     /* Set all the values to true.
     */
    proc fill() {
      for i in this.values.domain do
        this.values[i] = 0b11111111111111111111111111111111;
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

    /* rotate all the values to the right. Let values falling out on one side reappear on the rhs side.

    */
    proc rotr(shift : int) {

    }

    proc reverse() {
      this.values.reverse();
      forall i in this.values.domain do
        this.values[i] = this._reverse(this.values[i]);
    }

    /* rotate all the values to the left. Let values falling out on one side reappear on the rhs side.

    */
    proc rotl(shift : int) {
      var temp : uint(32) = 0;
      var D : domain(1);
      // for i in D do

    }

    /* Set the value at a given index.

       :idx: The index of the value to mutate.

       :value: The value to set.

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
     */
    proc size() {
      return this.bitSize;
    }

    /* Iterate over all the values.
     */
    iter these() {
      var packSizeMinusOne = packSize - 1;
      var it : uint(32) = 0;
      if this.hasRemaining {
        for i in this.values {
          var block = this.values[i];
          for j in {0..packSizeMinusOne} {
            if it < this.bitSize {
              var mask : uint(32) = one << j : uint(32);
              var bit = block & mask;
              yield bit != 0;

              it += 1;
            }
          }
        }
      } else {
        for i in this.values do {
          var block = this.values[i];
          for j in {0..packSizeMinusOne} {
            var mask : uint(32) = one << j : uint(32);
            var bit = block & mask;
            yield bit != 0;
          }
        }
      }
    }

    /* Set all the values to false.
     */
    proc unfill() {
      this.values = 0;
    }

    /* Compares two bit arrays by values with corresponding indices. All the values are set according to X[i] == Y[i] where X and Y are the to bit arrays to compare.

       :returns: A new BitArray1D with the result values.
     */
    operator ==(lhs : borrowed BitArray1D, rhs : borrowed BitArray1D) {
      var bitarray = new BitArray1D(lhs.size());
      bitarray.values = lhs.values ^ ~rhs.values;
      return bitarray;
    }

    /* Compares two bit arrays by values with corresponding indices. All the values are set according to X[i] != Y[i] where X and Y are the to bit arrays to compare.

       :returns: A new BitArray1D with the result values.
     */
    operator !=(lhs : borrowed BitArray1D, rhs : borrowed BitArray1D) {
      var bitarray = new BitArray1D(lhs.size());
      bitarray.values = lhs.values ^ rhs.values;
      return bitarray;
    }

    /* Copies the values from an rhs bit array.

       :arg rhs: The bit array to copy.
    */
    operator =(rhs : borrowed BitArray1D) {
      var values : [this.values.domain] uint(32);
      for i in rhs.bitDomain do
        values[i] = rhs.values[i];

      this.bitDomain = rhs.bitDomain;
      this.bitSize = rhs.bitSize;
      this.hasRemaining = rhs.hasRemaining;
      this.values = values;
    }

    /* Negate the values.
    */
    operator ~(arg : borrowed BitArray1D) {
      arg.values = ~arg.values;
      var mask = this._createReminderMask();
      arg.values[arg.values.domain.last] &= mask;
    }
    /* Shift all the values to the right. Left values are padded with false values.

       :shift: the number of values to shift.
     */
    operator <<(shift : int) {
      this._bitshift(shift);
    }


    /* Shift all the values to the right. Left values are padded with false values.

       :shift: the number of values to shift.
     */
    operator >>(shift : int) {
      this._bitshiftReverse(shift);
    }

    /* Perform xor the values with the corresponding values in the input bit array. X[i] ^ Y[i] is performed for all indices i where X and Y are bit arrays.
       If one of the two bit arrays has different size then indices fitting the shortes bit array are compared.

       :rhs: bit array to perform xor with
     */
    operator ^(lhs : borrowed BitArray1D, rhs : borrowed BitArray1D) {
      lhs.values = lhs.values ^ rhs.values;
      var mask = this._createReminderMask();
      lhs.values[lhs.values.domain.last] &= mask;
    }

    /* Perform the and operation on the values in this bit array with the values in anrhs bit array.
       If one of the two bit arrays has different size then indices fitting the shortes bit array are compared.

       :rhs: bit array to perform and with
     */
    operator &(lhs : borrowed BitArray1D, rhs : borrowed BitArray1D) {
      lhs.values = lhs.values & rhs.values;
      var mask = this._createReminderMask();
      lhs.values[lhs.values.domain.last] &= mask;
    }

    /* Perform the or operation on the values in this bit array with the values in anrhs bit array.
       If one of the two bit arrays has different size then indices fitting the shortes bit array are compared.

       :rhs: bit array to perform or with
     */
    operator |(lhs : borrowed BitArray1D, rhs : borrowed BitArray1D) {
      lhs.values = lhs.values || rhs.values;
      var mask = this._createReminderMask();
      lhs.values[lhs.values.domain.last] &= mask;
    }
  }
}
