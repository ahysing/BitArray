use UnitTest;
use BitArrays.BitArrays32;
use BitOps;

proc BitArray32__reverseWord_inputIs_1(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  test.assertEqual(bitArray._reverseWord(1 : uint(32)), 0b10000000000000000000000000000000 : uint(32));
}

proc BitArray32__reverseWord_inputIs_2(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  test.assertEqual(bitArray._reverseWord(2 : uint(32)), 0b01000000000000000000000000000000 : uint(32));
}

proc BitArray32__reverseWord_inputIs_3(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  test.assertEqual(bitArray._reverseWord(3 : uint(32)), 0b11000000000000000000000000000000 : uint(32));
}

proc BitArray32__reverseWord_inputIs_100(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  test.assertEqual(bitArray._reverseWord(100 : uint(32)), 0b00100110000000000000000000000000 : uint(32));
}

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

proc BitArray32_reverse(test: borrowed Test) throws {
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

proc BitArray32_reverse_sizeIs33_at0(test: borrowed Test) throws {
  var bitArray = new BitArray32(33);
  bitArray.set(0, true);
  bitArray.reverse();
  test.skip(reason="Failing test. work in progress...");
  test.assertTrue(bitArray.at(32));
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

proc BitArray32_rotateLeft_inputIs1_LastBitIsSet_ResultShouldRollBitOver(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[bitArray.values.domain.first] = 0b10000000000000000000000000000000;
  bitArray.rotateLeft(1);
  test.skip(reason="Failing test. work in progress...");
  test.assertEqual(bitArray.values[bitArray.values.domain.first], 0b00000000000000000000000000000001);
}

proc BitArray32_rotateLeft_inputIs2_LastBitIsSet_ResultShouldRollBitOver(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[bitArray.values.domain.first] = 0b10000000000000000000000000000000;
  bitArray.rotateLeft(2);
  test.skip(reason="Failing test. work in progress...");
  test.assertEqual(bitArray.values[bitArray.values.domain.first], 0b00000000000000000000000000000010);
}


proc BitArray32_rotateLeft_inputIs1_SizeIs64_LastBitIsSet_ResultShouldRollBitOver(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  bitArray.values[1] = 0b10000000000000000000000000000000;
  bitArray.rotateLeft(1);
  test.skip(reason="Failing test. work in progress...");
  test.assertEqual(bitArray.values[0], 0b00000000000000000000000000000001);
}

proc BitArray32_rotateLeft_inputIs2_SizeIs64_LastBitIsSet_ResultShouldRollBitOver(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  bitArray.values[1] = 0b10000000000000000000000000000000;
  bitArray.rotateLeft(2);
  test.skip(reason="Failing test. work in progress...");
  test.assertEqual(bitArray.values[0], 0b00000000000000000000000000000010);
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

proc BitArray32_rotateRight_valueIsTwpp_inputIs1(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[bitArray.values.domain.first] = 2;
  bitArray.rotateRight(1);
  test.assertEqual(bitArray.values[bitArray.values.domain.first], 0b00000000000000000000000000000001);
}

proc BitArray32_rotateRight_valueIsTwo_inputIs31(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[bitArray.values.domain.first] = 2;
  bitArray.rotateRight(31);
  test.assertEqual(bitArray.values[bitArray.values.domain.first], 0b00000000000000000000000000000100);
}

proc BitArray32_rotateRight_valueIsTwo_inputIs32(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[bitArray.values.domain.first] = 2;
  bitArray.rotateRight(32);
  test.assertEqual(bitArray.values[bitArray.values.domain.first], 0b00000000000000000000000000000010);
}

proc BitArray32_rotateRight_inputIs1_LastBitIsSet_ResultShouldRollBitOver(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[bitArray.values.domain.first] = 0b10000000000000000000000000000000;
  bitArray.rotateRight(1);
  test.skip(reason="work in progress...");
  test.assertEqual(bitArray.values[bitArray.values.domain.first], 0b00000000000000000000000000000001);
}

proc BitArray32_rotateRight_inputIs2_LastBitIsSet_ResultShouldRollBitOver(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  bitArray.values[bitArray.values.domain.first] = 0b10000000000000000000000000000000;
  bitArray.rotateRight(2);
  test.skip(reason="work in progress...");
  test.assertEqual(bitArray.values[bitArray.values.domain.first], 0b00000000000000000000000000000010);
}


proc BitArray32_rotateRight_inputIs1_SizeIs64_LastBitIsSet_ResultShouldRollBitOver(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  bitArray.values[1] = 0b10000000000000000000000000000000;
  bitArray.rotateRight(1);
  test.skip(reason="work in progress...");
  test.assertEqual(bitArray.values[0], 0b00000000000000000000000000000001);
}

proc BitArray32_rotateRight_inputIs2_SizeIs64_LastBitIsSet_ResultShouldRollBitOver(test: borrowed Test) throws {
  var bitArray = new BitArray32(64);
  bitArray.values[1] = 0b10000000000000000000000000000000;
  bitArray.rotateRight(2);
  test.skip(reason="work in progress...");
  test.assertEqual(bitArray.values[0], 0b00000000000000000000000000000010);
}









proc BitArray32__createShiftRolloverMask_sizeIsOne(test: borrowed Test) throws {
  var bitarray = new BitArray32(1 : uint(32));
  var reminderMask = bitarray._createShiftRolloverMask(1);
  test.assertEqual(reminderMask, 0b11111111111111111111111111111110);
}


proc BitArray32__createShiftRolloverMask_sizeIsTwo(test: borrowed Test) throws {
  var bitarray = new BitArray32(2 : uint(32));
  var reminderMask = bitarray._createShiftRolloverMask(2);
  test.assertEqual(reminderMask, 0b11111111111111111111111111111100);
}

proc BitArray32__createShiftRolloverMask_sizeIsThree(test: borrowed Test) throws {
  var bitarray = new BitArray32(3 : uint(32));
  var reminderMask = bitarray._createShiftRolloverMask(3);
  test.assertEqual(reminderMask, 0b11111111111111111111111111111000);
}

proc BitArray32__createShiftRolloverMask_sizeIsFour(test: borrowed Test) throws {
  var bitarray = new BitArray32(4 : uint(32));
  var reminderMask = bitarray._createShiftRolloverMask(4);
  test.assertEqual(reminderMask, 0b11111111111111111111111111110000);
}

proc BitArray32__createShiftRolloverMask_sizeIsFive(test: borrowed Test) throws {
  var bitarray = new BitArray32(5 : uint(32));
  var reminderMask = bitarray._createShiftRolloverMask(5);
  test.assertEqual(reminderMask, 0b11111111111111111111111111100000);
}

proc BitArray32__createShiftRolloverMask_sizeIsSeven(test: borrowed Test) throws {
  var bitarray = new BitArray32(7 : uint(32));
  var reminderMask = bitarray._createShiftRolloverMask(7);
  test.assertEqual(reminderMask, 0b11111111111111111111111110000000);
}


proc BitArray32__createShiftRolloverMask_sizeIsThirtyOne(test: borrowed Test) throws {
  var bitarray = new BitArray32(32 : uint(32));
  var reminderMask = bitarray._createShiftRolloverMask(31);
  test.assertEqual(reminderMask, 0b10000000000000000000000000000000);
}






proc BitArray32__createMainMask_sizeIsOne(test: borrowed Test) throws {
  var bitarray = new BitArray32(1 : uint(32));
  var reminderMask = bitarray._createMainMask(1);
  test.assertEqual(reminderMask, 0b00000000000000000000000000000001);
}


proc BitArray32__createMainMask_sizeIsTwo(test: borrowed Test) throws {
  var bitarray = new BitArray32(2 : uint(32));
  var reminderMask = bitarray._createMainMask(2);
  test.assertEqual(reminderMask, 0b00000000000000000000000000000011);
}

proc BitArray32__createMainMask_sizeIsThree(test: borrowed Test) throws {
  var bitarray = new BitArray32(3 : uint(32));
  var reminderMask = bitarray._createMainMask(3);
  test.assertEqual(reminderMask, 0b00000000000000000000000000000111);
}

proc BitArray32__createMainMask_sizeIsFour(test: borrowed Test) throws {
  var bitarray = new BitArray32(4 : uint(32));
  var reminderMask = bitarray._createMainMask(4);
  test.assertEqual(reminderMask, 0b00000000000000000000000000001111);
}

proc BitArray32__createMainMask_sizeIsFive(test: borrowed Test) throws {
  var bitarray = new BitArray32(5 : uint(32));
  var reminderMask = bitarray._createMainMask(5);
  test.assertEqual(reminderMask, 0b00000000000000000000000000011111);
}

proc BitArray32__createMainMask_sizeIsSeven(test: borrowed Test) throws {
  var bitarray = new BitArray32(7 : uint(32));
  var reminderMask = bitarray._createMainMask(7);
  test.assertEqual(reminderMask, 0b00000000000000000000000001111111);
}


proc BitArray32__createMainMask_sizeIsThirtyOne(test: borrowed Test) throws {
  var bitarray = new BitArray32(32 : uint(32));
  var reminderMask = bitarray._createMainMask(31);
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
  test.assertEqual(steps, 1);
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





proc BitArray32_pipe(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(2, true);
  var result = bitArrayA | bitArrayB;
  test.assertTrue(result.any());
}

proc BitArray32_pipe_bitAtIndexOneIsTrue(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(1, true);
  var result = bitArrayA | bitArrayB;
  test.assertTrue(result.any());
}

proc BitArray32_pipeEquals(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(2, true);
  bitArrayA |= bitArrayB;
  test.assertTrue(bitArrayA.any());
}


proc BitArray32_pipeEquals_bitAtIndexOneIsTrue(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(1, true);
  bitArrayA |= bitArrayB;
  test.assertTrue(bitArrayA.any());
}

proc BitArray32_pipe_inputisTrueatIndex1_outputIsTrueAtIndex1(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(1, true);
  var result = bitArrayA | bitArrayB;
  test.assertTrue(result.any());
}

proc BitArray32_pipeEquals_inputisTrueatIndex1_outputIsTrueAtIndex1(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  var result = bitArrayA | bitArrayB;
  test.assertTrue(result.any());
}

proc BitArray32_ampersand_inputisTrueatIndex1OnBothBitArrays_outputIsTrueAtIndex1(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(1, true);
  var result = bitArrayA & bitArrayB;
  test.assertTrue(result.any());
}

proc BitArray32_ampersand_inputisTrueatIndex1or2_outputIsFalse(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(2, true);
  var result = bitArrayA & bitArrayB;
  test.assertFalse(result.any());
}


proc BitArray32_ampersandAnd_inputisTrueatIndex1or2_outputIsFalse(test: borrowed Test) throws {
  var bitArrayA = new BitArray32(32);
  var bitArrayB = new BitArray32(32);
  bitArrayA.set(1, true);
  bitArrayB.set(2, true);
  bitArrayA &= bitArrayB;
  test.assertFalse(bitArrayA.any());
}

proc BitArray32_ampersandAnd_inputisTrueatIndex1onBoth_outputIsTrue(test: borrowed Test) throws {
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

UnitTest.main();