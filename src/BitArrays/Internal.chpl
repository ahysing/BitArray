pragma "no doc"
module Internal {
  use BitOps;
  use UnorderedAtomics;

  pragma "no doc"
  private const eightBitReversed : [0..255]uint(32) = [
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
  inline proc findNumberOfBlocks(values) {
    return values.domain.last - values.domain.first + 1;
  }

  pragma "no doc"
  proc unsignedAll(hasRemaining : bool, const packSize, size, values) {
    var _expectedOldValueTrue = true;
    var result : atomic bool = true;
    if hasRemaining then {
      var last = values.domain.last;
      var dom : subdomain(values.domain) = values.domain[..(last-1)];
      var result : atomic bool = true;
      forall i in dom do
        result.compareAndSwap(_expectedOldValueTrue, BitOps.popcount(values[i]) == packSize);

      var lastValues = values[last];
      result.compareAndSwap(_expectedOldValueTrue, BitOps.popcount(lastValues) == size % packSize);
    } else {
      forall i in values.domain do
        result.compareAndSwap(_expectedOldValueTrue, BitOps.popcount(values[i]) == packSize);
    }
    return result.read();
  }

  pragma "no doc"
  proc unsignedAny(values) {
    var _expectedOldValueFalse = false;
    var result : atomic bool = false;
    forall i in values.domain do
      result.compareAndSwap(_expectedOldValueFalse, values[i] != 0);
    return result.read();
  }

  pragma "no doc"
  proc getNumberOfBlocks(hasRemaining : bool, packSize, size) {
    var sizeAsInt = size / packSize;
    if hasRemaining then
      sizeAsInt = sizeAsInt + 1;
    return sizeAsInt;
  }

  pragma "no doc"
  proc _popcount(values) {
    var count : atomic uint(32) = 0;
    forall i in values.domain do
      count.unorderedAdd(BitOps.popcount(values[i]));
    return count.read();
  }

  pragma "no doc"
  proc _popcount2(values) {
    var v = values;
    forall i in values.domain do
      v[i] = BitOps.popcount(values[i]);
    return + reduce v;
  }

  pragma "no doc"
  inline proc reverse64(value : uint(64)) {
    var result : uint(64) = 0;
    var idx : uint(64);

    idx = value & 0xff;
    result = (eightBitReversed[idx]) << 56;

    idx = (value >> 8) & 0xff;
    result |= (eightBitReversed[idx]) << 48;

    idx = (value >> 16) & 0xff;
    result |= (eightBitReversed[idx]) << 40;

    idx = (value >> 24) & 0xff;
    result |= (eightBitReversed[idx]) << 32;

    idx = (value >> 32) & 0xff;
    result |= (eightBitReversed[idx]) << 24;

    idx = (value >> 40) & 0xff;
    result |= (eightBitReversed[idx]) << 16;

    idx = (value >> 48) & 0xff;
    result |= (eightBitReversed[idx]) << 8;

    idx = (value >> 56) & 0xff;
    result |= (eightBitReversed[idx]);

    return result;
  }

  pragma "no doc"
  inline proc reverse32(value : uint(32)) {
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
  inline proc reverse16(value :uint(16)) {
    var result : uint(16) = 0;
    var idx : uint(32);

    idx = value & 0xff;
    result = (eightBitReversed[idx]) << 8;

    idx = (value >> 8) & 0xff;
    result |= (eightBitReversed[idx]);

    return result;
  }

  pragma "no doc"
  proc reverse8(value :uint(8)) {
    return eightBitReversed[value] : uint(8);
  }

  pragma "no doc"
  proc unsignedAt(packSize, values, idx) {
    var pageIdx = idx / packSize + values.domain.first;
    var block  = values[pageIdx];
    var mask = (1 : values.eltType) << (idx % packSize);
    var bit = block & mask;
    return bit != 0;
  }

  pragma "no doc"
  proc unsignedSet(packSize, values, idx, value: bool) {
    var pageIdx = idx / packSize + values.domain.first;
    var block = values[pageIdx];
    var mask = (1 : values.eltType) << (idx % packSize);
    if value && (block & mask) == 0 then
      values[pageIdx] = block | mask;
    else if !value && (block & mask) != 0 then
      values[pageIdx] = block ^ mask;
  }
}