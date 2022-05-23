use UnitTest;
use BitArray;
use BitOps;

proc BitArray__createReminderMask(test: borrowed Test) throws {
  var bitarray = new BitArray1D(1 : uint(32));
  var reminderMask = bitarray._createReminderMask();
  test.assertEqual(reminderMask, 1);
}

proc BitArray__reverse_inputIs_1(test: borrowed Test) throws {
  var bitArray = new BitArray1D(32);
  test.assertEqual(bitArray._reverse(1 : uint(32)), 0b10000000000000000000000000000000 : uint(32));
}

proc BitArray__reverse_inputIs_2(test: borrowed Test) throws {
  var bitArray = new BitArray1D(32);
  test.assertEqual(bitArray._reverse(2 : uint(32)), 0b01000000000000000000000000000000 : uint(32));
}

proc BitArray__reverse_inputIs_3(test: borrowed Test) throws {
  var bitArray = new BitArray1D(32);
  test.assertEqual(bitArray._reverse(3 : uint(32)), 0b11000000000000000000000000000000 : uint(32));
}

proc BitArray__reverse_inputIs_100(test: borrowed Test) throws {
  var bitArray = new BitArray1D(32);
  test.assertEqual(bitArray._reverse(100 : uint(32)), 0b00100110000000000000000000000000 : uint(32));
}

proc BitArray_rotl_inputIs1(test: borrowed Test) throws {
  var bitArray = new BitArray1D(32);
  bitArray.values[bitArray.values.domain.first] = 1;
  bitArray.rotl(1);
  test.assertEqual(bitArray.values[bitArray.values.domain.first], 0b00000000000000000000000000000010);
}

proc BitArray_rotl_inputIs31(test: borrowed Test) throws {
  var bitArray = new BitArray1D(32);
  bitArray.values[bitArray.values.domain.first] = 1;
  bitArray.rotl(31);
  test.assertEqual(bitArray.values[bitArray.values.domain.first], 0b10000000000000000000000000000000);
}

proc BitArray__createReminderMask_sizeIsTwo(test: borrowed Test) throws {
  var bitarray = new BitArray1D(2 : uint(32));
  var reminderMask = bitarray._createReminderMask();
  test.assertEqual(reminderMask, 3);
}

proc BitArray__createReminderMask_sizeIsSixtyFive(test: borrowed Test) throws {
  var bitarray = new BitArray1D(65 : uint(32));
  var reminderMask = bitarray._createReminderMask();
  test.assertEqual(reminderMask, 1);
}

proc BitArray_constructor(test: borrowed Test) throws {
  var bitArray = new BitArray1D(32);
  test.assertEqual(bitArray.size(), 32);
}

proc BitArray_constructorSize1(test: borrowed Test) throws {
  var bitArray = new BitArray1D(1);
  test.assertEqual(bitArray.size(), 1);
}

proc BitArray_constructorSize64(test: borrowed Test) throws {
  var bitArray = new BitArray1D(64);
  test.assertEqual(bitArray.size(), 64);
}

proc BitArray_size_size65(test: borrowed Test) throws {
  var bitArray = new BitArray1D(65);
  test.assertEqual(bitArray.size(), 65);
}

proc BitArray_equals(test: borrowed Test) throws {
  var bitArray = new BitArray1D(64);
  var otherArray = new BitArray1D(64);
  test.assertTrue(bitArray.equals(otherArray));
}

proc BitArray_equals_inputIs64BitArrayWithSingleTrue(test: borrowed Test) throws {
  var bitArray = new BitArray1D(64);
  bitArray.set(1, true);
  var otherArray = new BitArray1D(64);
  test.assertFalse(bitArray.equals(otherArray));
}

proc BitArray_fill(test: borrowed Test) throws {
  var otherArray = new BitArray1D(65);
  otherArray.fill();
  test.assertEqual(otherArray.values[otherArray.values.domain.last], 1);
}

proc BitArray_equalsInputIsNotEqual(test: borrowed Test) throws {
  var bitArray = new BitArray1D(64);
  var otherArray = new BitArray1D(64);
  otherArray.fill();
  test.assertFalse(bitArray.equals(otherArray));
}

proc BitArray_assign(test: borrowed Test) throws {
  var bitArray = new BitArray1D(64);
  var otherArray : BitArray1D = bitArray;
  test.assertTrue(otherArray != nil);
}

proc BitArray_at(test: borrowed Test) throws {
  var bitArray = new BitArray1D(32);

  bitArray.values[bitArray.values.domain.first] = 0b00000000000000000000000000000001;

  test.assertTrue(bitArray.at(0));
}

proc BitArray_at_inputIsTrueAtIndexThirtyOne(test: borrowed Test) throws {
  var bitArray = new BitArray1D(32);

  bitArray.values[bitArray.values.domain.first] = 0b10000000000000000000000000000000;

  test.assertTrue(bitArray.at(31));
}

proc BitArray_atSizeWithReminder(test: borrowed Test) throws {
  var bitArray = new BitArray1D(65);
  bitArray.fill();
  test.assertTrue(bitArray.at(64));
}

proc BitArray_size_inputIs32(test: borrowed Test) throws {
  var bitArray = new BitArray1D(32);
  var i = 0;
  for _x in bitArray.values.domain do
    i += 1;
  test.assertEqual(1, i);
}
proc BitArray_size_inputIs33(test: borrowed Test) throws {
  var bitArray = new BitArray1D(33);
  var i = 0;
  for _x in bitArray.values.domain do
    i += 1;
  test.assertEqual(i, 2);
}

proc BitArray_size_inputIs64(test: borrowed Test) throws {
  var bitArray = new BitArray1D(64);
  var i = 0;
  for _x in bitArray.values.domain do
    i += 1;
  test.assertEqual(i, 2);
}

proc BitArray_size_inputIs65_sizeIs3Blocks(test: borrowed Test) throws {
  var bitArray = new BitArray1D(65);
  var i = 0;
  for _x in bitArray.values.domain do
    i += 1;
  test.assertEqual(i, 3);
}

proc BitArray__getNumberOfBlocks(test: borrowed Test) throws {
  var size = 1 : uint(32);
  var packSize = 32 : uint(32);
  var hasRemaining = (size % packSize) != 0;
  var sizeAsInt : uint(32) = (new BitArray1D(1))._getNumberOfBlocks(hasRemaining, size);
  test.assertEqual(sizeAsInt, 1);
}

proc BitArray_popcount_inputIs32(test: borrowed Test) throws {
  var bitArray = new BitArray1D(32);
  bitArray.fill();
  test.assertEqual(bitArray.popcount(), 32);
}

proc BitArray_popcount_inputIs64(test: borrowed Test) throws {
  var bitArray = new BitArray1D(64);
  bitArray.fill();
  test.assertEqual(bitArray.popcount(), 64);
}

proc BitArray_popcount_inputIs1(test: borrowed Test) throws {
  var bitArray = new BitArray1D(1);
  bitArray.fill();

  test.assertEqual(bitArray.popcount(), 1);
}

proc BitArray_popcount_inputIs31(test: borrowed Test) throws {
  var bitArray = new BitArray1D(31);
  bitArray.fill();

  test.assertEqual(bitArray.popcount(), 31);
}

proc BitArray_popcount_inputIs33(test: borrowed Test) throws {
  var bitArray = new BitArray1D(33);
  bitArray.fill();

  test.assertEqual(bitArray.popcount(), 33);
}

proc BitArray_popcount(test: borrowed Test) throws {
  var bitArray = new BitArray1D(65);
  bitArray.fill();
  test.assertEqual(bitArray.popcount(), 65);
}

proc BitArray_these(test: borrowed Test) throws {
  var bitArray = new BitArray1D(65);
  var steps = 0;
  for i in bitArray.these() do
    steps += 1;
  test.assertEqual(steps, 65);
}

proc BitArray_set(test: borrowed Test) throws {
  var bitArray = new BitArray1D(32);
  bitArray.set(0, true);

  test.assertEqual(bitArray.values[0], 0b00000000000000000000000000000001);
}


proc BitArray_set_inputIsTrueAtIndexOne(test: borrowed Test) throws {
  var bitArray = new BitArray1D(32);
  bitArray.set(1, true);

  test.assertEqual(bitArray.values[0], 0b00000000000000000000000000000010);
}

UnitTest.main();