use UnitTest;
use BitArrays.BitArrays32;
use BitOps;

proc BitArray32_all_sizeIs64_inputIs64Trues(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  bitArray.values[0] = ~0 : uint(32);
  bitArray.values[1] = ~0 : uint(32);
  test.assertTrue(bitArray.all());
}

proc BitArray32_all_sizeIs33_inputIs33Trues(test: borrowed Test) throws {
  var bitArray = new BitArray32(33);
  bitArray.values[0] = ~0 : uint(32);
  bitArray.values[1] = 1 : uint(32);
  test.assertTrue(bitArray.all());
}

proc BitArray32_any_sizeIs33_inputIs33False(test: borrowed Test) throws {
  var bitArray = new BitArray32(33);
  test.assertFalse(bitArray.any());
}

proc BitArray32_any_sizeIs33_inputIsOneTrue(test: borrowed Test) throws {
  var bitArray = new BitArray32(33);
  bitArray.set(1, true);
  test.assertTrue(bitArray.any());
}

proc BitArray32_any_sizeIs64_inputIs64False(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  test.assertFalse(bitArray.any());
}

proc BitArray32_any_sizeIs64_inputIs64Trues(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  bitArray.values[0] = ~0 : uint(32);
  bitArray.values[1] = ~0 : uint(32);
  test.assertTrue(bitArray.any());
}

proc BitArray32_any_sizeIs33_inputIs33Trues(test: borrowed Test) throws {
  var bitArray = new BitArray32(33);
  bitArray.values[0] = ~0 : uint(32);
  bitArray.values[1] = 1 : uint(32);
  test.assertTrue(bitArray.any());
}

proc BitArray32_reverse_outputIsNotNil(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.reverse();
  test.assertTrue(bitArray != nil);
  test.assertFalse(bitArray.all());
}

proc BitArray32_reverse_fillThenReverse_returnsFull(test: borrowed Test) throws {
  var bitArray = new BitArray32(33);
  bitArray.fill();
  bitArray.reverse();
  test.assertTrue(bitArray.all());
}

proc BitArray32_reverse_at0(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.set(0, true);
  bitArray.reverse();
  test.assertTrue(bitArray.at(31));
}

proc BitArray32_reverse_at1(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.set(1, true);
  bitArray.reverse();
  test.assertTrue(bitArray.at(30));
}

proc BitArray32_reverse_at2(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.set(2, true);
  bitArray.reverse();
  test.assertTrue(bitArray.at(29));
}

proc BitArray32_reverse_bitIsSetAt0_sizeIs33(test: borrowed Test) throws {
  var bitArray = new BitArray32(33);
  bitArray.set(0, true);

  bitArray.reverse();

  var expected = new BitArray32(33);
  expected.values[0] = 0;
  expected.values[1] = 1;
  test.assertEqual(expected.values, bitArray.values);
}

proc BitArray32_reverse(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  bitArray.values[0] = 0b01010011001100001111000011110000;
  bitArray.values[1] = 0b00000000000000000000000000000000;

  bitArray.reverse();

  var expected = new BitArray32(64);
  expected.values[0] = 0b00000000000000000000000000000000;
  expected.values[1] = 0b00001111000011110000110011001010;
  test.assertEqual(expected.values, bitArray.values);
}

proc BitArray32__rotateLeftWholeBlock_sizeIs32(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[0] = 0;

  bitArray._rotateLeftWholeBlock();

  test.assertEqual(0, bitArray.values[0]);
}


proc BitArray32__rotateLeftWholeBlock_sizeIs64(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  bitArray.values[0] = 0;
  bitArray.values[1] = 1;

  bitArray._rotateLeftWholeBlock();

  var expected = new BitArray32(64);
  expected.values[0] = 1;
  expected.values[1] = 0;
  test.assertEqual(expected.values, bitArray.values);
}

proc BitArray32__rotateLeftWholeBlock_sizeIs96(test: borrowed Test) throws {
  var bitArray = new BitArray32(96);
  bitArray.values[0] = 0;
  bitArray.values[1] = 1;
  bitArray.values[2] = 2;

  bitArray._rotateLeftWholeBlock();

  var expected = new BitArray32(96);
  expected.values[0] = 2;
  expected.values[1] = 0;
  expected.values[2] = 1;
  test.assertEqual(expected.values, bitArray.values);
}

proc BitArray32__rotateLeftWholeBlock_sizeIs128(test: borrowed Test) throws {
  var bitArray = new BitArray32(128);
  bitArray.values[0] = 0;
  bitArray.values[1] = 1;
  bitArray.values[2] = 2;
  bitArray.values[3] = 3;

  bitArray._rotateLeftWholeBlock();

  var expected = new BitArray32(128);
  expected.values[0] = 3;
  expected.values[1] = 0;
  expected.values[2] = 1;
  expected.values[3] = 2;
  test.assertEqual(expected.values, bitArray.values);
}

proc BitArray32__rotateLeftWholeBlock_sizeIs256(test: borrowed Test) throws {
  var bitArray = new BitArray32(256);
  bitArray.values[0] = 0;
  bitArray.values[1] = 1;
  bitArray.values[2] = 2;
  bitArray.values[3] = 3;
  bitArray.values[4] = 4;
  bitArray.values[5] = 5;
  bitArray.values[6] = 6;
  bitArray.values[7] = 7;

  bitArray._rotateLeftWholeBlock();

  var expected = new BitArray32(256);

  expected.values[0] = 7;
  expected.values[1] = 0;
  expected.values[2] = 1;
  expected.values[3] = 2;
  expected.values[4] = 3;
  expected.values[5] = 4;
  expected.values[6] = 5;
  expected.values[7] = 6;

  test.assertEqual(expected.values, bitArray.values);
}

proc BitArray32_rotateLeft_inputIs1(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[bitArray.values.domain.first] = 1;
  bitArray.rotateLeft(1);
  test.assertEqual(bitArray.values[bitArray.values.domain.first], 0b00000000000000000000000000000010);
}

proc BitArray32_rotateLeft_inputIs31(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[bitArray.values.domain.first] = 1;
  bitArray.rotateLeft(31);
  test.assertEqual(bitArray.values[bitArray.values.domain.first], 0b10000000000000000000000000000000);
}

proc BitArray32_rotateLeft_valueIsTwo_inputIs31(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[bitArray.values.domain.first] = 2;
  bitArray.rotateLeft(31);
  test.assertEqual(0b00000000000000000000000000000001, bitArray.values[bitArray.values.domain.first]);
}

proc BitArray32_rotateLeft_valueIsTwo_inputIs1(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[bitArray.values.domain.first] = 2;
  bitArray.rotateLeft(1);
  test.assertEqual(0b00000000000000000000000000000100, bitArray.values[bitArray.values.domain.first]);
}

proc BitArray32_rotateLeft_valueIsTwo_inputIs2(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[bitArray.values.domain.first] = 2;
  bitArray.rotateLeft(2);
  test.assertEqual(0b00000000000000000000000000001000, bitArray.values[bitArray.values.domain.first]);
}

proc BitArray32_rotateLeft_inputIs1_LastBitIsSet_ResultShouldRollBitOver(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[bitArray.values.domain.first] = 0b10000000000000000000000000000000;
  bitArray.rotateLeft(1);

  test.assertEqual(bitArray.values[bitArray.values.domain.first], 0b00000000000000000000000000000001);
}

proc BitArray32_rotateLeft_inputIs2_LastBitIsSet_ResultShouldRollBitOver(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[bitArray.values.domain.first] = 0b10000000000000000000000000000000;
  bitArray.rotateLeft(2);

  test.assertEqual(bitArray.values[bitArray.values.domain.first], 0b00000000000000000000000000000010);
}

proc BitArray32_rotateLeft_inputIs1_SizeIs64_LastBitIsSet_ResultShouldRollBitOver(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  bitArray.values[0] = 0;
  bitArray.values[1] = 0b10000000000000000000000000000000;

  bitArray.rotateLeft(1);

  var expected = new BitArray32(64);
  expected.values[0] = 0b00000000000000000000000000000001;
  expected.values[1] = 0;

  test.assertEqual(expected.values, bitArray.values);
}

proc BitArray32_rotateLeft_inputIs2_SizeIs64_LastBitIsSet_ResultShouldRollBitOver(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  bitArray.values[0] = 0;
  bitArray.values[1] = 0b10000000000000000000000000000000;

  bitArray.rotateLeft(2);

  var expected = new BitArray32(64);
  expected.values[0] = 0b00000000000000000000000000000010;
  expected.values[1] = 0;

  test.assertEqual(expected.values, bitArray.values);
}






proc BitArray32__rotateRightWholeBlock_sizeIs32(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[0] = 0;

  bitArray._rotateRightWholeBlock();

  var expected = new BitArray32(32);
  expected.values[0] = 0;

  test.assertEqual(expected.values, bitArray.values);
}


proc BitArray32__rotateRightWholeBlock_sizeIs64(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  bitArray.values[0] = 0;
  bitArray.values[1] = 1;

  bitArray._rotateRightWholeBlock();

  var expected = new BitArray32(64);
  expected.values[0] = 1;
  expected.values[1] = 0;
  test.assertEqual(expected.values, bitArray.values);
}

proc BitArray32__rotateRightWholeBlock_sizeIs96(test: borrowed Test) throws {
  var bitArray = new BitArray32(96);
  bitArray.values[0] = 0;
  bitArray.values[1] = 1;
  bitArray.values[2] = 2;

  bitArray._rotateRightWholeBlock();

  var expected = new BitArray32(96);
  expected.values[0] = 1;
  expected.values[1] = 2;
  expected.values[2] = 0;
  test.assertEqual(expected.values, bitArray.values);
}

proc BitArray32__rotateRightWholeBlock_sizeIs128(test: borrowed Test) throws {
  var bitArray = new BitArray32(128);
  bitArray.values[0] = 0;
  bitArray.values[1] = 1;
  bitArray.values[2] = 2;
  bitArray.values[3] = 3;

  bitArray._rotateRightWholeBlock();

  var expected = new BitArray32(128);
  expected.values[0] = 1;
  expected.values[1] = 2;
  expected.values[2] = 3;
  expected.values[3] = 0;
  test.assertEqual(expected.values, bitArray.values);
}

proc BitArray32__rotateRightWholeBlock_inputIsOneToFour_sizeIs128(test: borrowed Test) throws {
  var bitArray = new BitArray32(128);
  bitArray.values[0] = 1;
  bitArray.values[1] = 2;
  bitArray.values[2] = 3;
  bitArray.values[3] = 4;

  bitArray._rotateRightWholeBlock();

  var expected = new BitArray32(128);
  expected.values[0] = 2;
  expected.values[1] = 3;
  expected.values[2] = 4;
  expected.values[3] = 1;
  test.assertEqual(expected.values, bitArray.values);
}

proc BitArray32__rotateRightWholeBlock_sizeIs256(test: borrowed Test) throws {
  var bitArray = new BitArray32(256);
  bitArray.values[0] = 0;
  bitArray.values[1] = 1;
  bitArray.values[2] = 2;
  bitArray.values[3] = 3;
  bitArray.values[4] = 4;
  bitArray.values[5] = 5;
  bitArray.values[6] = 6;
  bitArray.values[7] = 7;

  bitArray._rotateRightWholeBlock();

  var expected = new BitArray32(256);
  expected.values[0] = 1;
  expected.values[1] = 2;
  expected.values[2] = 3;
  expected.values[3] = 4;
  expected.values[4] = 5;
  expected.values[5] = 6;
  expected.values[6] = 7;
  expected.values[7] = 0;

  test.assertEqual(expected.values, bitArray.values);
}

proc BitArray32_rotateRightNbits_valueIsOne_inputIs1(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[bitArray.values.domain.first] = 1;
  bitArray._rotateRightNBits(1);
  test.assertEqual(bitArray.values[bitArray.values.domain.first], 0b10000000000000000000000000000000);
}

proc BitArray32_rotateRight_valueIsOne_inputIs1(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[bitArray.values.domain.first] = 1;
  bitArray.rotateRight(1);
  test.assertEqual(bitArray.values[bitArray.values.domain.first], 0b10000000000000000000000000000000);
}

proc BitArray32_rotateRight_valueIsOne_inputIs31(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[bitArray.values.domain.first] = 1;
  bitArray.rotateRight(31);
  test.assertEqual(bitArray.values[bitArray.values.domain.first], 0b00000000000000000000000000000010);
}

proc BitArray32_rotateRight_valueIsTwo_inputIs1(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[0] = 2;
  bitArray.rotateRight(1);
  test.assertEqual(bitArray.values[0], 0b00000000000000000000000000000001);
}

proc BitArray32_rotateRight_valueIsTwo_inputIs31(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[bitArray.values.domain.first] = 2;
  bitArray.rotateRight(31);
  test.assertEqual(0b00000000000000000000000000000100, bitArray.values[bitArray.values.domain.first]);
}

proc BitArray32_rotateRight_valueIsTwo_inputIs32(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[bitArray.values.domain.first] = 2;
  bitArray.rotateRight(32);
  test.assertEqual(bitArray.values[bitArray.values.domain.first], 0b00000000000000000000000000000010);
}

proc BitArray32_rotateRight_inputIs1_firstBitIsSet_ResultShouldRollBitOver(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[0] = 0b00000000000000000000000000000001;
  bitArray.rotateRight(1);

  test.assertEqual(bitArray.values[0], 0b10000000000000000000000000000000);
}

proc BitArray32_rotateRight_inputIs2_firstBitIsSet_ResultShouldRollBitOver(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[bitArray.values.domain.first] = 0b00000000000000000000000000000001;

  bitArray.rotateRight(2);

  test.assertEqual(bitArray.values[bitArray.values.domain.first], 0b01000000000000000000000000000000);
}


proc BitArray32_rotateRight_inputIs1_SizeIs64_firstBitIsSet_ResultShouldRollBitOver(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  bitArray.values[0] = 0b00000000000000000000000000000001;

  bitArray.rotateRight(1);

  var expected = new BitArray32(64);
  expected.values[1] = 0b10000000000000000000000000000000;

  test.assertEqual(expected.values, bitArray.values);
}






proc BitArray32__createMainMaskRight_sizeIsOne(test: borrowed Test) throws {
  var bitarray = new BitArray32(1 : uint(32));
  var reminderMask = bitarray._createMainMaskRight(1);
  test.assertEqual(reminderMask, 0b01111111111111111111111111111111);
}


proc BitArray32__createMainMaskRight_sizeIsTwo(test: borrowed Test) throws {
  var bitarray = new BitArray32(1 : uint(32));
  var reminderMask = bitarray._createMainMaskRight(2);
  test.assertEqual(reminderMask, 0b00111111111111111111111111111111);
}


proc BitArray32__createMainMaskToLeft_sizeIsOne(test: borrowed Test) throws {
  var bitarray = new BitArray32(1 : uint(32));
  var reminderMask = bitarray._createMainMaskToLeft(1);
  test.assertEqual(reminderMask, 0b11111111111111111111111111111110);
}


proc BitArray32__createMainMaskToLeft_sizeIsTwo(test: borrowed Test) throws {
  var bitarray = new BitArray32(2 : uint(32));
  var reminderMask = bitarray._createMainMaskToLeft(2);
  test.assertEqual(reminderMask, 0b11111111111111111111111111111100);
}

proc BitArray32__createMainMaskToLeft_sizeIsThree(test: borrowed Test) throws {
  var bitarray = new BitArray32(3 : uint(32));
  var reminderMask = bitarray._createMainMaskToLeft(3);
  test.assertEqual(reminderMask, 0b11111111111111111111111111111000);
}

proc BitArray32__createMainMaskToLeft_sizeIsFour(test: borrowed Test) throws {
  var bitarray = new BitArray32(4 : uint(32));
  var reminderMask = bitarray._createMainMaskToLeft(4);
  test.assertEqual(reminderMask, 0b11111111111111111111111111110000);
}

proc BitArray32__createMainMaskToLeft_sizeIsFive(test: borrowed Test) throws {
  var bitarray = new BitArray32(5 : uint(32));
  var reminderMask = bitarray._createMainMaskToLeft(5);
  test.assertEqual(reminderMask, 0b11111111111111111111111111100000);
}

proc BitArray32__createMainMaskToLeft_sizeIsSeven(test: borrowed Test) throws {
  var bitarray = new BitArray32(7 : uint(32));
  var reminderMask = bitarray._createMainMaskToLeft(7);
  test.assertEqual(reminderMask, 0b11111111111111111111111110000000);
}


proc BitArray32__createMainMaskToLeft_sizeIsThirtyOne(test: borrowed Test) throws {
  var bitarray = new BitArray32(32 : uint(32));
  var reminderMask = bitarray._createMainMaskToLeft(31);
  test.assertEqual(reminderMask, 0b10000000000000000000000000000000);
}






proc BitArray32__createShiftRolloverMask_sizeIsOne(test: borrowed Test) throws {
  var bitarray = new BitArray32(1 : uint(32));
  var reminderMask = bitarray._createShiftRolloverMask(1);
  test.assertEqual(reminderMask, 0b00000000000000000000000000000001);
}


proc BitArray32__createShiftRolloverMask_sizeIsTwo(test: borrowed Test) throws {
  var bitarray = new BitArray32(2 : uint(32));
  var reminderMask = bitarray._createShiftRolloverMask(2);
  test.assertEqual(reminderMask, 0b00000000000000000000000000000011);
}

proc BitArray32__createShiftRolloverMask_sizeIsThree(test: borrowed Test) throws {
  var bitarray = new BitArray32(3 : uint(32));
  var reminderMask = bitarray._createShiftRolloverMask(3);
  test.assertEqual(reminderMask, 0b00000000000000000000000000000111);
}

proc BitArray32__createShiftRolloverMask_sizeIsFour(test: borrowed Test) throws {
  var bitarray = new BitArray32(4 : uint(32));
  var reminderMask = bitarray._createShiftRolloverMask(4);
  test.assertEqual(reminderMask, 0b00000000000000000000000000001111);
}

proc BitArray32__createShiftRolloverMask_sizeIsFive(test: borrowed Test) throws {
  var bitarray = new BitArray32(5 : uint(32));
  var reminderMask = bitarray._createShiftRolloverMask(5);
  test.assertEqual(reminderMask, 0b00000000000000000000000000011111);
}

proc BitArray32__createShiftRolloverMask_sizeIsSeven(test: borrowed Test) throws {
  var bitarray = new BitArray32(7 : uint(32));
  var reminderMask = bitarray._createShiftRolloverMask(7);
  test.assertEqual(reminderMask, 0b00000000000000000000000001111111);
}


proc BitArray32__createShiftRolloverMask_sizeIsThirtyOne(test: borrowed Test) throws {
  var bitarray = new BitArray32(32 : uint(32));
  var reminderMask = bitarray._createShiftRolloverMask(31);
  test.assertEqual(reminderMask, 0b01111111111111111111111111111111);
}



proc BitArray32_constructor(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  test.assertEqual(bitArray.size(), 32);
}

proc BitArray32_constructorSize1(test: borrowed Test) throws {
  var bitArray = new BitArray32(1);
  test.assertEqual(bitArray.size(), 1);
}

proc BitArray32_constructorSize64(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  test.assertEqual(bitArray.size(), 64);
}

proc BitArray32_size_size65(test: borrowed Test) throws {
  var bitArray = new BitArray32(65);
  test.assertEqual(bitArray.size(), 65);
}

proc BitArray32_equals(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  var otherArray = new BitArray32(64);
  test.assertTrue(bitArray.equals(otherArray));
}

proc BitArray32_equals_inputIs64BitArrayWithSingleTrue(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  bitArray.set(1, true);
  var otherArray = new BitArray32(64);
  test.assertFalse(bitArray.equals(otherArray));
}

proc BitArray32_fill(test: borrowed Test) throws {
  var otherArray = new BitArray32(65);
  otherArray.fill();
  test.assertEqual(otherArray.values[otherArray.values.domain.last], 1);
}

proc BitArray32_equalsInputIsNotEqual(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  var otherArray = new BitArray32(64);
  otherArray.fill();
  test.assertFalse(bitArray.equals(otherArray));
}

proc BitArray32_assign(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  var otherArray : BitArray32 = bitArray;
  test.assertTrue(otherArray != nil);
}

proc BitArray32_at(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);

  bitArray.values[bitArray.values.domain.first] = 0b00000000000000000000000000000001;

  test.assertTrue(bitArray.at(0));
}

proc BitArray32_at_inputIsTrueAtIndexThirtyOne(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);

  bitArray.values[bitArray.values.domain.first] = 0b10000000000000000000000000000000;

  test.assertTrue(bitArray.at(31));
}

proc BitArray32_atSizeWithReminder(test: borrowed Test) throws {
  var bitArray = new BitArray32(65);
  bitArray.fill();
  test.assertTrue(bitArray.at(64));
}

proc BitArray32_size_inputIs32(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  var i = 0;
  for _x in bitArray.values.domain do
    i += 1;
  test.assertEqual(1, i);
}
proc BitArray32_size_inputIs33(test: borrowed Test) throws {
  var bitArray = new BitArray32(33);
  var i = 0;
  for _x in bitArray.values.domain do
    i += 1;
  test.assertEqual(i, 2);
}

proc BitArray32_size_inputIs64(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  var i = 0;
  for _x in bitArray.values.domain do
    i += 1;
  test.assertEqual(i, 2);
}

proc BitArray32_size_inputIs65_sizeIs3Blocks(test: borrowed Test) throws {
  var bitArray = new BitArray32(65);
  var i = 0;
  for _x in bitArray.values.domain do
    i += 1;
  test.assertEqual(i, 3);
}

proc BitArray32_popcount_inputIs32(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.fill();
  test.assertEqual(bitArray.popcount(), 32);
}

proc BitArray32_popcount_inputIs64(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  bitArray.fill();
  test.assertEqual(bitArray.popcount(), 64);
}

proc BitArray32_popcount_inputIs1(test: borrowed Test) throws {
  var bitArray = new BitArray32(1);
  bitArray.fill();

  test.assertEqual(bitArray.popcount(), 1);
}

proc BitArray32_popcount_inputIs31(test: borrowed Test) throws {
  var bitArray = new BitArray32(31);
  bitArray.fill();

  test.assertEqual(bitArray.popcount(), 31);
}

proc BitArray32_popcount_inputIs33(test: borrowed Test) throws {
  var bitArray = new BitArray32(33);
  bitArray.fill();

  test.assertEqual(bitArray.popcount(), 33);
}

proc BitArray32_popcount(test: borrowed Test) throws {
  var bitArray = new BitArray32(65);
  bitArray.fill();
  test.assertEqual(bitArray.popcount(), 65);
}


proc BitArray32_these_inputHas1Values_OutputHas1Values(test: borrowed Test) throws {
  var bitArray = new BitArray32(1);
  var steps = 0;
  for i in bitArray.these() do
    steps += 1;
  test.assertEqual(1, steps);
}

proc BitArray32_these_inputHas63Values_OutputHas63Values(test: borrowed Test) throws {
  var bitArray = new BitArray32(63);
  var steps = 0;
  for i in bitArray.these() do
    steps += 1;
  test.assertEqual(steps, 63);
}

proc BitArray32_these_inputHas63Values_OutputHas64Values(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  var steps = 0;
  for i in {1..63} do
    bitArray.set(i, i % 2 == 1);

  var it = 0;
  for i in bitArray.these() {
    test.assertEqual(i, i % 2 == 1);
    it += 1;
  }
}

proc BitArray32_these_inputHas64Values_OutputHas64Values(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  var steps = 0;
  for i in bitArray.these() do
    steps += 1;
  test.assertEqual(steps, 64);
}

proc BitArray32_these_inputHas65Values_OutputHas65Values(test: borrowed Test) throws {
  var bitArray = new BitArray32(65);
  var steps = 0;
  for i in bitArray.these() do
    steps += 1;
  test.assertEqual(steps, 65);
}

proc BitArray_trueIndicies(test: borrowed Test) throws {
  var bitArray = new BitArray32(8);
  bitArray.set(1, true);
  bitArray.set(3, false);
  bitArray.set(3, true);
  var expected : domain((int, bool)) = [
    (0, false),
    (1, true),
    (2, false),
    (3, true),
    (4, false),
    (5, false),
    (6, false),
    (7, false),
  ];
  var result : domain((int, bool));
  for (value, i) in zip(bitArray.these(), 0..) do
    result += (i, value);
  test.assertEqual(expected, result);
}

proc BitArray_trueIndicies_allValuesAreSet(test: borrowed Test) throws {
  var bitArray = new BitArray32(8);
  bitArray.fill();
  var expected : domain((int, bool)) = [
    (0, true),
    (1, true),
    (2, true),
    (3, true),
    (4, true),
    (5, true),
    (6, true),
    (7, true),
  ];
  var result : domain((int, bool));
  for (value, i) in zip(bitArray.these(), 0..) do
    result += (i, value);
  test.assertEqual(expected, result);
}

proc BitArray_trueIndicies_inputHas32Values_outputHas32Values(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  var size = 0;
  for bitArray.these() do
    size += 1;
  var expected = 32;
  test.assertEqual(expected, size);
}

proc BitArray_trueIndicies_inputHas33Values_outputHas33Values(test: borrowed Test) throws {
  var bitArray = new BitArray32(33);
  var size = 0;
  for bitArray.these() do
    size += 1;
  var expected = 33;
  test.assertEqual(expected, size);
}

proc BitArray32_bitshiftLeftNBits(test : borrowed Test) throws {
  var bitArray = new BitArray32(256);
  // all these values ha 1 as the least signifficat bit.
  // When shifting 1 bit to the right we expect the 1 bit to end up as the most signifcant bit
  // in the number AKA index above.
  bitArray.values[0] = 1 + 2147483648;
  bitArray.values[1] = 2 + 2147483648;
  bitArray.values[2] = 4 + 2147483648;
  bitArray.values[3] = 8 + 2147483648;
  bitArray.values[4] = 16 + 2147483648;
  bitArray.values[5] = 32 + 2147483648;
  bitArray.values[6] = 64 + 2147483648;
  bitArray.values[7] = 128 + 2147483648;

  bitArray._bitshiftLeftNBits(1);

  var expected = new BitArray32(256);
  expected.values[0] = 2 + 0;
  expected.values[1] = 4 + 1;
  expected.values[2] = 8 + 1;
  expected.values[3] = 16 + 1;
  expected.values[4] = 32 + 1;
  expected.values[5] = 64 + 1;
  expected.values[6] = 128 + 1;
  expected.values[7] = 256 + 1;

  test.assertEqual(expected.values, bitArray.values);
}

proc BitArray32_bitshiftRightNBits(test : borrowed Test) throws {
  var bitArray = new BitArray32(256);
  // all these values ha 1 as the least signifficat bit.
  // When shifting 1 bit to the right we expect the 1 bit to end up as the most signifcant bit
  // in the number AKA index below.
  bitArray.values[0] = 1;
  bitArray.values[1] = 3;
  bitArray.values[2] = 5;
  bitArray.values[3] = 9;
  bitArray.values[4] = 17;
  bitArray.values[5] = 33;
  bitArray.values[6] = 65;
  bitArray.values[7] = 129;

  bitArray._bitshiftRightNBits(1);

  var expected = new BitArray32(256);
  expected.values[0] = 0 + 2147483648;
  expected.values[1] = 1 + 2147483648;
  expected.values[2] = 2 + 2147483648;
  expected.values[3] = 4 + 2147483648;
  expected.values[4] = 8 + 2147483648;
  expected.values[5] = 16 + 2147483648;
  expected.values[6] = 32 + 2147483648;
  expected.values[7] = 64 + 0;

  test.assertEqual(expected.values, bitArray.values);
}

proc BitArray32_set(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.set(0, true);

  test.assertEqual(bitArray.values[0], 0b00000000000000000000000000000001);
}

proc BitArray32_set_inputIsTrueAtIndexOne(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.set(1, true);

  test.assertEqual(bitArray.values[0], 0b00000000000000000000000000000010);
}

proc BitArray32_set_oddValuesAreTrue(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  for i in {1..31} do
    bitArray.set(i, i % 2 == 1);

  for i in {1..31} do
    test.assertEqual(bitArray.at(i), i % 2 == 1);
}

proc BitArray32_ampersand(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(2, true);
  var result = bitArrayA & bitArrayB;
  test.assertFalse(result.any());
}

proc BitArray32_ampersand_bitAtIndexOneIsTrue(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(1, true);
  var result = bitArrayA & bitArrayB;
  test.assertTrue(result.any());
}

proc BitArray32_ampersand_LeftIsSmallerThanRight(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(33);
  bitArrayA.fill();
  bitArrayB.fill();
  var result = bitArrayA & bitArrayB;
  test.assertTrue(result.all());
}

proc BitArray32_ampersand_RightIsSmallerThanLeft(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(33);
  var bitArrayB = new BitArray32(32);
  bitArrayA.fill();
  bitArrayB.fill();
  var result = bitArrayA & bitArrayB;
  test.assertFalse(result.all());
}

proc BitArray32_ampersandEquals(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(2, true);
  bitArrayA &= bitArrayB;
  test.assertFalse(bitArrayA.any());
}

proc BitArray32_ampersandEquals_bitAtIndexOneIsTrue(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(1, true);
  bitArrayA &= bitArrayB;
  test.assertTrue(bitArrayA.any());
}




proc BitArray32_minus_LeftIsSmallerThanRight(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(33);
  bitArrayA.fill();
  bitArrayB.fill();
  var result = bitArrayA - bitArrayB;
  test.assertFalse(result.all());
}

proc BitArray32_minus_RightIsSmallerThanLeft(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(33);
  var bitArrayB = new BitArray32(32);
  bitArrayA.fill();
  bitArrayB.fill();

  var result = bitArrayA - bitArrayB;

  var expected = new BitArray32(33);
  expected.values[0] = 0;
  expected.values[1] = 1;
  test.assertEqual(expected.values, result.values);
}


proc BitArray32_minus_RightIsSmallerThanLeft_sizeCopiedFromLeftHandSide(test: borrowed Test) throws {
  var size = 33;
  var bitArrayA = new BitArray32(size);
  var bitArrayB = new BitArray32(32);
  bitArrayA.fill();
  bitArrayB.fill();

  var result = bitArrayA - bitArrayB;

  test.assertEqual(size, result.size());
}


proc BitArray32_minus(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(2, true);

  var result = bitArrayA - bitArrayB;

  var expected = new BitArray32(32);
  expected.set(1, true);
  test.assertEqual(expected.values, bitArrayA.values);
}


proc BitArray32_minusEquals(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(2, true);

  bitArrayA -= bitArrayB;

  var expected = new BitArray32(32);
  expected.set(1, true);
  test.assertEqual(expected.values, bitArrayA.values);
}

proc BitArray32_minusEquals_bitAtIndexOneIsTrue(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(1, true);

  bitArrayA -= bitArrayB;

  test.assertFalse(bitArrayA.any());
}





proc BitArray32_pipe(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(2, true);
  var result = bitArrayA + bitArrayB;
  test.assertTrue(result.any());
}

proc BitArray32_pluss_bitAtIndexOneIsTrue(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(1, true);
  var result = bitArrayA + bitArrayB;
  test.assertTrue(result.any());
}
proc BitArray32_pluss(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(2, true);

  var result = bitArrayA + bitArrayB;

  var expected = new BitArray32(32);
  expected.set(1, true);
  expected.set(2, true);
  test.assertEqual(expected.values, result.values);
}

proc BitArray32_plussEquals(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(2, true);

  bitArrayA += bitArrayB;

  var expected = new BitArray32(32);
  expected.set(1, true);
  expected.set(2, true);
  test.assertEqual(expected.values, bitArrayA.values);
}

proc BitArray32_plussEquals_bitAtIndexOneIsTrue(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(1, true);
  bitArrayA += bitArrayB;
  test.assertTrue(bitArrayA.any());
}

proc BitArray32_pluss_inputisTrueatIndex1_outputIsTrueAtIndex1(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(1, true);
  var result = bitArrayA + bitArrayB;
  test.assertTrue(result.any());
}

proc BitArray32_plussEquals_inputisTrueatIndex1_outputIsTrueAtIndex1(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB += bitArrayA;
  test.assertTrue(bitArrayB.any());
}

proc BitArray32_minus_inputisTrueatIndex1OnBothBitArrays_outputIsTrueAtIndex1(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(1, true);
  var result = bitArrayA & bitArrayB;
  test.assertTrue(result.any());
}

proc BitArray32_minus_inputisTrueatIndex1or2_outputIsFalse(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(2, true);
  var result = bitArrayA & bitArrayB;
  test.assertFalse(result.any());
}


proc BitArray32_ampersandEquals_inputisTrueatIndex1or2_outputIsFalse(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(2, true);
  bitArrayA &= bitArrayB;
  test.assertFalse(bitArrayA.any());
}

proc BitArray32_ampersandEquals_inputisTrueatIndex1onBoth_outputIsTrue(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(1, true);
  bitArrayA &= bitArrayB;
  test.assertTrue(bitArrayA.any());
}

proc BitArray32_not_outputIsTrue(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  var result = !bitArray;
  test.assertTrue(result.all());
}

proc BitArray32_xor_inputisTrueatIndex1onBoth_outputIsFalse(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(1, true);
  var result = bitArrayA ^ bitArrayB;
  test.assertFalse(result.any());
}

proc BitArray32_xor_inputisTrueatIndex1and2_outputIsTrue(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(2, true);
  var result = bitArrayA ^ bitArrayB;
  test.assertTrue(result.any());
}

proc BitArray32_xorEquals_inputisTrueatIndex1onBoth_outputIsFalse(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(1, true);
  bitArrayA ^= bitArrayB;
  test.assertFalse(bitArrayA.any());
}

proc BitArray32_xorEquals_inputisTrueatIndex1and2_outputIsTrue(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(2, true);
  bitArrayA ^= bitArrayB;
  test.assertTrue(bitArrayA.any());
}

proc BitArray32__bitshiftLeftWholeBlock_inputIsLower32BitsSet_sizeIs64(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  bitArray.values[0] = 0b11111111111111111111111111111111 : uint(32);

  bitArray._bitshiftLeftWholeBlock();

  test.assertEqual(0 : uint(32), bitArray.values[0]);
  test.assertEqual(0b11111111111111111111111111111111 : uint(32), bitArray.values[1]);
}

proc BitArray32__bitshiftLeftWholeBlock_inputIsLower32BitsSet_sizeIs128(test: borrowed Test) throws {
  var bitArray = new BitArray32(128);
  bitArray.values[0] = 0b11111111111111111111111111111111 : uint(32);
  bitArray.values[1] = 0b10101010101010101010101010101010 : uint(32);
  bitArray.values[2] = 0;
  bitArray.values[3] = 0;

  bitArray._bitshiftLeftWholeBlock();

  test.assertEqual(0 : uint(32), bitArray.values[0]);
  test.assertEqual(0b11111111111111111111111111111111 : uint(32), bitArray.values[1]);
  test.assertEqual(0b10101010101010101010101010101010 : uint(32), bitArray.values[2]);
  test.assertEqual(0 : uint(32), bitArray.values[3]);
}

proc BitArray32__bitshiftLeftWholeBlock_inputIsUpper32BitSet_sizeIs64(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  for i in {32..63} do
    bitArray.set(i, true);
  bitArray._bitshiftLeftWholeBlock();
  test.assertFalse(bitArray.any());
}

proc BitArray32__bitshiftLeftWholeBlock_inputIs32_sizeIs64(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  bitArray.set(0, true);
  bitArray._bitshiftLeftWholeBlock();
  test.assertEqual(bitArray.values[1], 0b00000000000000000000000000000001 : uint(32));
}

proc BitArray32__bitshiftLeftWholeBlock_sizeIs256(test: borrowed Test) throws {
  var bitArray = new BitArray32(256);
  bitArray.values[0] = 0;
  bitArray.values[1] = 1;
  bitArray.values[2] = 2;
  bitArray.values[3] = 3;
  bitArray.values[4] = 4;
  bitArray.values[5] = 5;
  bitArray.values[6] = 6;
  bitArray.values[7] = 7;

  bitArray._bitshiftLeftWholeBlock();

  var expected = new BitArray32(256);

  expected.values[0] = 0;
  expected.values[1] = 0;
  expected.values[2] = 1;
  expected.values[3] = 2;
  expected.values[4] = 3;
  expected.values[5] = 4;
  expected.values[6] = 5;
  expected.values[7] = 6;

  test.assertEqual(expected.values, bitArray.values);
}

proc BitArray32_bitshiftLeftNBits_inputIs2(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.set(0, true);
  bitArray._bitshiftLeftNBits(2);
  test.assertEqual(0b00000000000000000000000000000100, bitArray.values[0]);
}



proc BitArray32__bitshiftLeftNBits_sizeIs128(test: borrowed Test) throws {
  var bitArray = new BitArray32(128);
  bitArray.values[0] = 0;
  bitArray.values[1] = 1;
  bitArray.values[2] = 2;
  bitArray.values[3] = 3;

  bitArray._bitshiftLeftNBits(1);

  var expected = new BitArray32(128);
  expected.values[0] = 0;
  expected.values[1] = 2;
  expected.values[2] = 4;
  expected.values[3] = 6;
  test.assertEqual(expected.values, bitArray.values);
}

proc BitArray32__bitshiftLeftNBits_sizeIs256(test: borrowed Test) throws {
  var bitArray = new BitArray32(256);
  bitArray.values[0] = 0;
  bitArray.values[1] = 1;
  bitArray.values[2] = 2;
  bitArray.values[3] = 3;
  bitArray.values[4] = 4;
  bitArray.values[5] = 5;
  bitArray.values[6] = 6;
  bitArray.values[7] = 7;

  bitArray._bitshiftLeftNBits(1);

  var expected = new BitArray32(256);

  expected.values[0] = 0;
  expected.values[1] = 2;
  expected.values[2] = 4;
  expected.values[3] = 6;
  expected.values[4] = 8;
  expected.values[5] = 10;
  expected.values[6] = 12;
  expected.values[7] = 14;

  test.assertEqual(expected.values, bitArray.values);
}

// TODO
proc BitArray32__bitshiftLeftNBits_inputIs31_sizeIs128(test: borrowed Test) throws {
  var bitArray = new BitArray32(128);
  bitArray.values[0] = 0;
  bitArray.values[1] = 1;
  bitArray.values[2] = 2;
  bitArray.values[3] = 0;

  bitArray._bitshiftLeftNBits(31);

  var expected = new BitArray32(128);

  expected.values[0] = 0;
  expected.values[1] = 0b10000000000000000000000000000000;
  expected.values[2] = 0b00000000000000000000000000000000;
  expected.values[3] = 0b00000000000000000000000000000001;

  test.assertEqual(expected.values, bitArray.values);
}

proc BitArray32_operatorShiftLeft_inputIs2(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.set(0, true);
  var result = bitArray << 2;
  test.assertEqual(0b00000000000000000000000000000100, result.values[0]);
}


proc BitArray32_operatorShiftLeft_inputIs32(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.set(0, true);
  var result = bitArray << 32;
  test.assertFalse(result.any());
}


proc BitArray32_operatorShiftLeft_inputIs32_sizeIs64(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  bitArray.set(0, true);
  var result = bitArray << 32;
  test.assertEqual(result.values[1], 0b00000000000000000000000000000001 : uint(32));
}


proc BitArray32_operatorShiftLeftEquals_inputIs2(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.set(0, true);
  bitArray <<= 2;
  test.assertEqual(0b00000000000000000000000000000100, bitArray.values[0]);
}

proc BitArray32_operatorShiftLeftEquals_inputIs32(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.set(0, true);
  bitArray <<= 32;
  test.assertFalse(bitArray.any());
}

proc BitArray32_operatorShiftLeftEquals_inputIs32_sizeIs64(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  bitArray.set(0, true);
  bitArray <<= 32;
  test.assertEqual(bitArray.values[1], 0b00000000000000000000000000000001 : uint(32));
}




proc BitArray32_operatorShiftRight_inputIs2(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.set(2, true);
  var result = bitArray >> 2;
  test.assertEqual(0b00000000000000000000000000000001, result.values[0]);
}


proc BitArray32_operatorShiftRight_inputIs32(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.set(31, true);
  var result = bitArray >> 32;
  test.assertFalse(result.any());
}


proc BitArray32_operatorShiftRight_inputIs32_sizeIs64(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  bitArray.set(32, true);
  var result = bitArray >> 32;
  test.assertEqual(result.values[0], 0b00000000000000000000000000000001 : uint(32));
}


proc BitArray32_operatorShiftRightEquals_inputIs2(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.set(4, true);
  bitArray >>= 2;
  test.assertEqual(0b00000000000000000000000000000100, bitArray.values[0]);
}

proc BitArray32_operatorShiftRightEquals_inputIs32(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.set(31, true);
  bitArray >>= 32;
  test.assertFalse(bitArray.any());
}

proc BitArray32_operatorShiftRightEquals_inputIs32_sizeIs64(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  bitArray.set(32, true);
  bitArray >>= 32;
  test.assertEqual(bitArray.values[0], 0b00000000000000000000000000000001 : uint(32));
}

UnitTest.main();