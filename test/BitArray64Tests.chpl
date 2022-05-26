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

UnitTest.main();