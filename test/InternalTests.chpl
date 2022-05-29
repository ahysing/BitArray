use UnitTest;

proc Internal_unsignedAll_inputIs128Bits_valuesAreTrue(test: borrowed Test) {
    var values : [0..1]uint(64);
    const packSize = 64;
    values[0] = ~0;
    values[1] = ~0;
    var result = unsignedAll(false, packSize, values);
    test.assertTrue(result);
}

proc Internal_unsignedAll_inputIs128Bits_valuesAreZeroThenOne(test: borrowed Test) {
    var values : [0..1]uint(64);
    const packSize = 64;
    const size = 128;
    values[0] = 0xAAAAAAAAAAAAAAAA;
    values[1] = 0xAAAAAAAAAAAAAAAA;
    var result = unsignedAll(false, packSize, size, values);
    test.assertFalse(result);
}

proc Internal_unsignedAll_inputIs128Bits_valuesAreZeroThenOne(test: borrowed Test) {
    var values : [0..1]uint(64);
    const packSize = 64;
    const size = 128;
    values[0] = 0xAAAAAAAAAAAAAAAA;
    values[1] = 0xAAAAAAAAAAAAAAAA;
    var result = unsignedAll(false, packSize, size, values);
    test.assertFalse(result);
}

proc Internal_unsignedAll_inputIs66its_valuesAreZeroThenOne(test: borrowed Test) {
    var values : [0..1]uint(64);
    const packSize = 64;
    const size = 65;
    values[0] = 0xAAAAAAAAAAAAAAAA;
    values[1] = 0xA;
    var result = unsignedAll(false, packSize, size, values);
    test.assertFalse(result);
}

UnitTest.main();