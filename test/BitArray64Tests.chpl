use UnitTest;
use BitArrays.BitArrays64;
use BitOps;

proc BitArray64__createReminderMask(test: borrowed Test) throws {
  var bitarray = new BitArray64(1 : uint(32));
}

proc BitArray64_set(test: borrowed Test) throws {
  var bitArray = new BitArray64(32);
  bitArray.set(0, true);

  test.assertEqual(bitArray.values[0], 0b00000000000000000000000000000001);
}

proc BitArray64_set_inputIsTrueAtIndexOne(test: borrowed Test) throws {
  var bitArray = new BitArray64(32);
  bitArray.set(1, true);

  test.assertEqual(bitArray.values[0], 0b00000000000000000000000000000010);
}


proc BitArray64_these_inputHas63Values_OutputHas63Values(test: borrowed Test) throws {
  var bitArray = new BitArray64(63);
  var steps = 0;
  for i in bitArray.these() do
    steps += 1;
  test.assertEqual(steps, 63);
}

proc BitArray64_these_inputHas64Values_OutputHas64Values(test: borrowed Test) throws {
  var bitArray = new BitArray64(64);
  var steps = 0;
  for i in bitArray.these() do
    steps += 1;
  test.assertEqual(steps, 64);
}

proc BitArray64_these_inputHas65Values_OutputHas65Values(test: borrowed Test) throws {
  var bitArray = new BitArray64(65);
  var steps = 0;
  for i in bitArray.these() do
    steps += 1;
  test.assertEqual(steps, 65);
}

proc BitArray64_reverse(test: borrowed Test) throws {
  var bitArray = new BitArray64(64);
  bitArray.values[0] = 0b0101001100110000111100001111000000000000000000000000000000000000;

  bitArray.reverse();

  var expected = new BitArray64(64);
  expected.values[0] = 0b0000000000000000000000000000000000001111000011110000110011001010;
  test.assertEqual(expected.values, bitArray.values);
}

proc BitArray64_reverse_inputSizeIs63(test: borrowed Test) throws {
  var bitArray = new BitArray64(63);
  bitArray.values[0] = 0b0101001100110000111100001111000000000000000000000000000000000000;

  bitArray.reverse();

  var expected = new BitArray64(63);
  expected.values[0] = 0b0000000000000000000000000000000000000111100001111000011001100101;
  test.assertEqual(expected.values, bitArray.values);
}




proc BitArray64_operatorShiftLeft_inputIs2(test: borrowed Test) throws {
  var bitArray = new BitArray64(32);
  bitArray.set(0, true);
  var result = bitArray << 2;
  test.assertEqual(0b00000000000000000000000000000100, result.values[0]);
}

proc BitArray64_operatorShiftLeft_inputIs31(test: borrowed Test) throws {
  var bitArray = new BitArray64(32);
  bitArray.set(0, true);
  var result = bitArray << 31;
  test.assertEqual(0b10000000000000000000000000000000, bitArray.values[0]);
}

proc BitArray64_operatorShiftLeft_inputIs32(test: borrowed Test) throws {
  var bitArray = new BitArray64(32);
  bitArray.set(0, true);
  var result = bitArray << 32;
  test.assertEqual(0, bitArray.values[0]);
}

proc BitArray64_operatorShiftLeft_inputIs32_sizeIs64(test: borrowed Test) throws {
  var bitArray = new BitArray64(64);
  bitArray.set(0, true);
  var result = bitArray << 32;
  test.assertEqual(result.values[0], 0b0000000000000000000000000000000100000000000000000000000000000000 : uint(64));
}


proc BitArray64_operatorShiftLeftEquals_inputIs2(test: borrowed Test) throws {
  var bitArray = new BitArray64(32);
  bitArray.set(0, true);
  bitArray <<= 2;
  test.assertEqual(0b00000000000000000000000000000100, bitArray.values[0]);
}

proc BitArray64_operatorShiftLeftEquals_inputIs32(test: borrowed Test) throws {
  var bitArray = new BitArray64(32);
  bitArray.set(0, true);
  bitArray <<= 32;
  test.assertFalse(bitArray.any());
}

proc BitArray64_operatorShiftLeftEquals_inputIs32_sizeIs64(test: borrowed Test) throws {
  var bitArray = new BitArray64(64);
  bitArray.set(0, true);
  bitArray <<= 32;
  test.assertEqual(bitArray.values[1], 0b00000000000000000000000000000001 : uint(32));
}




proc BitArray64_operatorShiftRight_inputIs2(test: borrowed Test) throws {
  var bitArray = new BitArray64(32);
  bitArray.set(2, true);
  var result = bitArray >> 2;
  test.assertEqual(0b00000000000000000000000000000001, result.values[0]);
}


proc BitArray64_operatorShiftRight_inputIs32(test: borrowed Test) throws {
  var bitArray = new BitArray64(32);
  bitArray.set(31, true);
  var result = bitArray >> 32;
  test.assertFalse(result.any());
}


proc BitArray64_operatorShiftRight_inputIs32_sizeIs64(test: borrowed Test) throws {
  var bitArray = new BitArray64(64);
  bitArray.set(32, true);
  var result = bitArray >> 32;
  test.assertEqual(result.values[0], 0b00000000000000000000000000000001 : uint(32));
}


proc BitArray64_operatorShiftRightEquals_inputIs2(test: borrowed Test) throws {
  var bitArray = new BitArray64(32);
  bitArray.set(4, true);
  bitArray >>= 2;
  test.assertEqual(0b00000000000000000000000000000100, bitArray.values[0]);
}

proc BitArray64_operatorShiftRightEquals_inputIs32(test: borrowed Test) throws {
  var bitArray = new BitArray64(32);
  bitArray.set(31, true);
  bitArray >>= 32;
  test.assertFalse(bitArray.any());
}

proc BitArray64_operatorShiftRightEquals_inputIs32_sizeIs64(test: borrowed Test) throws {
  var bitArray = new BitArray64(64);
  bitArray.set(32, true);
  bitArray >>= 32;
  test.assertEqual(bitArray.values[0], 0b00000000000000000000000000000001 : uint(32));
}

UnitTest.main();