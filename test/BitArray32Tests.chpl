use UnitTest;
use BitArrays.BitArrays32;
use BitOps;

proc BitArray32__createReminderMask(test: borrowed Test) throws {
  var bitarray = new BitArray32(1 : uint(32));
  var reminderMask = bitarray._createReminderMask();
  test.assertEqual(reminderMask, 1);
}

proc BitArray32__reverse_inputIs_1(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  test.assertEqual(bitArray._reverse(1 : uint(32)), 0b10000000000000000000000000000000 : uint(32));
}

proc BitArray32__reverse_inputIs_2(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  test.assertEqual(bitArray._reverse(2 : uint(32)), 0b01000000000000000000000000000000 : uint(32));
}

proc BitArray32__reverse_inputIs_3(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  test.assertEqual(bitArray._reverse(3 : uint(32)), 0b11000000000000000000000000000000 : uint(32));
}

proc BitArray32__reverse_inputIs_100(test: borrowed Test) throws {
  var bitArray = new BitArray32(32);
  test.assertEqual(bitArray._reverse(100 : uint(32)), 0b00100110000000000000000000000000 : uint(32));
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

proc BitArray32__createReminderMask_sizeIsTwo(test: borrowed Test) throws {
  var bitarray = new BitArray32(2 : uint(32));
  var reminderMask = bitarray._createReminderMask();
  test.assertEqual(reminderMask, 3);
}

proc BitArray32__createReminderMask_sizeIsSixtyFive(test: borrowed Test) throws {
  var bitarray = new BitArray32(65 : uint(32));
  var reminderMask = bitarray._createReminderMask();
  test.assertEqual(reminderMask, 1);
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

proc BitArray32__getNumberOfBlocks(test: borrowed Test) throws {
  var size = 1 : uint(32);
  var packSize = 32 : uint(32);
  var hasRemaining = (size % packSize) != 0;
  var sizeAsInt : uint(32) = (new BitArray32(1))._getNumberOfBlocks(hasRemaining, size);
  test.assertEqual(sizeAsInt, 1);
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

proc BitArray32_these(test: borrowed Test) throws {
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

UnitTest.main();