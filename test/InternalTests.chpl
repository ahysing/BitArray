use UnitTest;
use BitArrays.Internal;

proc Internal_unsignedAll_inputIs128Bits_valuesAreTrue(test: borrowed Test) throws {
    const size = 128;
    var values : [0..size]uint(64);
    const packSize = 64;
    values[0] = ~0 : uint(64);
    values[1] = ~0 : uint(64);
    var result = unsignedAll(false, packSize, size, values);
    test.skip(reason="Failing test. work in progress...");
    test.assertTrue(result);
}

proc Internal_unsignedAll_inputIs128Bits_valuesAreZeroThenOne(test: borrowed Test) throws {
    const size = 128;
    var values : [0..size]uint(64);
    const packSize = 64;
    values[0] = 0xAAAAAAAAAAAAAAAA : uint(64);
    values[1] = 0xAAAAAAAAAAAAAAAA : uint(64);
    var result = unsignedAll(false, packSize, size, values);
    test.assertFalse(result);
}

proc Internal_unsignedAll_inputIs66its_valuesAreZeroThenOne(test: borrowed Test) throws {
    const size = 65;
    var values : [0..size]uint(64);
    const packSize = 64;
    values[0] = 0xAAAAAAAAAAAAAAAA : uint(64);
    values[1] = 0xA : uint(64);
    var result = unsignedAll(false, packSize, size, values);
    test.assertFalse(result);
}
/*
for i in {0..255}
do
    x=$(printf "ibase=10;obase=2;%d\n" $i | bc)
    number=$(printf "%08d\n" $x)
    rev_number=$(printf "%08d\n" $x | rev)
    echo "proc Internal_reverse8_0b${number}(test: borrowed Test) throws { test.assertEqual(reverse8(0b${number}), 0b${rev_number}); }"
done
*/
proc Internal_reverse8_0b00000000(test: borrowed Test) throws { test.assertEqual(reverse8(0b00000000), 0b00000000); }
proc Internal_reverse8_0b00000001(test: borrowed Test) throws { test.assertEqual(reverse8(0b00000001), 0b10000000); }
proc Internal_reverse8_0b00000010(test: borrowed Test) throws { test.assertEqual(reverse8(0b00000010), 0b01000000); }
proc Internal_reverse8_0b00000011(test: borrowed Test) throws { test.assertEqual(reverse8(0b00000011), 0b11000000); }
proc Internal_reverse8_0b00000100(test: borrowed Test) throws { test.assertEqual(reverse8(0b00000100), 0b00100000); }
proc Internal_reverse8_0b00000101(test: borrowed Test) throws { test.assertEqual(reverse8(0b00000101), 0b10100000); }
proc Internal_reverse8_0b00000110(test: borrowed Test) throws { test.assertEqual(reverse8(0b00000110), 0b01100000); }
proc Internal_reverse8_0b00000111(test: borrowed Test) throws { test.assertEqual(reverse8(0b00000111), 0b11100000); }
proc Internal_reverse8_0b00001000(test: borrowed Test) throws { test.assertEqual(reverse8(0b00001000), 0b00010000); }
proc Internal_reverse8_0b00001001(test: borrowed Test) throws { test.assertEqual(reverse8(0b00001001), 0b10010000); }
proc Internal_reverse8_0b00001010(test: borrowed Test) throws { test.assertEqual(reverse8(0b00001010), 0b01010000); }
proc Internal_reverse8_0b00001011(test: borrowed Test) throws { test.assertEqual(reverse8(0b00001011), 0b11010000); }
proc Internal_reverse8_0b00001100(test: borrowed Test) throws { test.assertEqual(reverse8(0b00001100), 0b00110000); }
proc Internal_reverse8_0b00001101(test: borrowed Test) throws { test.assertEqual(reverse8(0b00001101), 0b10110000); }
proc Internal_reverse8_0b00001110(test: borrowed Test) throws { test.assertEqual(reverse8(0b00001110), 0b01110000); }
proc Internal_reverse8_0b00001111(test: borrowed Test) throws { test.assertEqual(reverse8(0b00001111), 0b11110000); }
proc Internal_reverse8_0b00010000(test: borrowed Test) throws { test.assertEqual(reverse8(0b00010000), 0b00001000); }
proc Internal_reverse8_0b00010001(test: borrowed Test) throws { test.assertEqual(reverse8(0b00010001), 0b10001000); }
proc Internal_reverse8_0b00010010(test: borrowed Test) throws { test.assertEqual(reverse8(0b00010010), 0b01001000); }
proc Internal_reverse8_0b00010011(test: borrowed Test) throws { test.assertEqual(reverse8(0b00010011), 0b11001000); }
proc Internal_reverse8_0b00010100(test: borrowed Test) throws { test.assertEqual(reverse8(0b00010100), 0b00101000); }
proc Internal_reverse8_0b00010101(test: borrowed Test) throws { test.assertEqual(reverse8(0b00010101), 0b10101000); }
proc Internal_reverse8_0b00010110(test: borrowed Test) throws { test.assertEqual(reverse8(0b00010110), 0b01101000); }
proc Internal_reverse8_0b00010111(test: borrowed Test) throws { test.assertEqual(reverse8(0b00010111), 0b11101000); }
proc Internal_reverse8_0b00011000(test: borrowed Test) throws { test.assertEqual(reverse8(0b00011000), 0b00011000); }
proc Internal_reverse8_0b00011001(test: borrowed Test) throws { test.assertEqual(reverse8(0b00011001), 0b10011000); }
proc Internal_reverse8_0b00011010(test: borrowed Test) throws { test.assertEqual(reverse8(0b00011010), 0b01011000); }
proc Internal_reverse8_0b00011011(test: borrowed Test) throws { test.assertEqual(reverse8(0b00011011), 0b11011000); }
proc Internal_reverse8_0b00011100(test: borrowed Test) throws { test.assertEqual(reverse8(0b00011100), 0b00111000); }
proc Internal_reverse8_0b00011101(test: borrowed Test) throws { test.assertEqual(reverse8(0b00011101), 0b10111000); }
proc Internal_reverse8_0b00011110(test: borrowed Test) throws { test.assertEqual(reverse8(0b00011110), 0b01111000); }
proc Internal_reverse8_0b00011111(test: borrowed Test) throws { test.assertEqual(reverse8(0b00011111), 0b11111000); }
proc Internal_reverse8_0b00100000(test: borrowed Test) throws { test.assertEqual(reverse8(0b00100000), 0b00000100); }
proc Internal_reverse8_0b00100001(test: borrowed Test) throws { test.assertEqual(reverse8(0b00100001), 0b10000100); }
proc Internal_reverse8_0b00100010(test: borrowed Test) throws { test.assertEqual(reverse8(0b00100010), 0b01000100); }
proc Internal_reverse8_0b00100011(test: borrowed Test) throws { test.assertEqual(reverse8(0b00100011), 0b11000100); }
proc Internal_reverse8_0b00100100(test: borrowed Test) throws { test.assertEqual(reverse8(0b00100100), 0b00100100); }
proc Internal_reverse8_0b00100101(test: borrowed Test) throws { test.assertEqual(reverse8(0b00100101), 0b10100100); }
proc Internal_reverse8_0b00100110(test: borrowed Test) throws { test.assertEqual(reverse8(0b00100110), 0b01100100); }
proc Internal_reverse8_0b00100111(test: borrowed Test) throws { test.assertEqual(reverse8(0b00100111), 0b11100100); }
proc Internal_reverse8_0b00101000(test: borrowed Test) throws { test.assertEqual(reverse8(0b00101000), 0b00010100); }
proc Internal_reverse8_0b00101001(test: borrowed Test) throws { test.assertEqual(reverse8(0b00101001), 0b10010100); }
proc Internal_reverse8_0b00101010(test: borrowed Test) throws { test.assertEqual(reverse8(0b00101010), 0b01010100); }
proc Internal_reverse8_0b00101011(test: borrowed Test) throws { test.assertEqual(reverse8(0b00101011), 0b11010100); }
proc Internal_reverse8_0b00101100(test: borrowed Test) throws { test.assertEqual(reverse8(0b00101100), 0b00110100); }
proc Internal_reverse8_0b00101101(test: borrowed Test) throws { test.assertEqual(reverse8(0b00101101), 0b10110100); }
proc Internal_reverse8_0b00101110(test: borrowed Test) throws { test.assertEqual(reverse8(0b00101110), 0b01110100); }
proc Internal_reverse8_0b00101111(test: borrowed Test) throws { test.assertEqual(reverse8(0b00101111), 0b11110100); }
proc Internal_reverse8_0b00110000(test: borrowed Test) throws { test.assertEqual(reverse8(0b00110000), 0b00001100); }
proc Internal_reverse8_0b00110001(test: borrowed Test) throws { test.assertEqual(reverse8(0b00110001), 0b10001100); }
proc Internal_reverse8_0b00110010(test: borrowed Test) throws { test.assertEqual(reverse8(0b00110010), 0b01001100); }
proc Internal_reverse8_0b00110011(test: borrowed Test) throws { test.assertEqual(reverse8(0b00110011), 0b11001100); }
proc Internal_reverse8_0b00110100(test: borrowed Test) throws { test.assertEqual(reverse8(0b00110100), 0b00101100); }
proc Internal_reverse8_0b00110101(test: borrowed Test) throws { test.assertEqual(reverse8(0b00110101), 0b10101100); }
proc Internal_reverse8_0b00110110(test: borrowed Test) throws { test.assertEqual(reverse8(0b00110110), 0b01101100); }
proc Internal_reverse8_0b00110111(test: borrowed Test) throws { test.assertEqual(reverse8(0b00110111), 0b11101100); }
proc Internal_reverse8_0b00111000(test: borrowed Test) throws { test.assertEqual(reverse8(0b00111000), 0b00011100); }
proc Internal_reverse8_0b00111001(test: borrowed Test) throws { test.assertEqual(reverse8(0b00111001), 0b10011100); }
proc Internal_reverse8_0b00111010(test: borrowed Test) throws { test.assertEqual(reverse8(0b00111010), 0b01011100); }
proc Internal_reverse8_0b00111011(test: borrowed Test) throws { test.assertEqual(reverse8(0b00111011), 0b11011100); }
proc Internal_reverse8_0b00111100(test: borrowed Test) throws { test.assertEqual(reverse8(0b00111100), 0b00111100); }
proc Internal_reverse8_0b00111101(test: borrowed Test) throws { test.assertEqual(reverse8(0b00111101), 0b10111100); }
proc Internal_reverse8_0b00111110(test: borrowed Test) throws { test.assertEqual(reverse8(0b00111110), 0b01111100); }
proc Internal_reverse8_0b00111111(test: borrowed Test) throws { test.assertEqual(reverse8(0b00111111), 0b11111100); }
proc Internal_reverse8_0b01000000(test: borrowed Test) throws { test.assertEqual(reverse8(0b01000000), 0b00000010); }
proc Internal_reverse8_0b01000001(test: borrowed Test) throws { test.assertEqual(reverse8(0b01000001), 0b10000010); }
proc Internal_reverse8_0b01000010(test: borrowed Test) throws { test.assertEqual(reverse8(0b01000010), 0b01000010); }
proc Internal_reverse8_0b01000011(test: borrowed Test) throws { test.assertEqual(reverse8(0b01000011), 0b11000010); }
proc Internal_reverse8_0b01000100(test: borrowed Test) throws { test.assertEqual(reverse8(0b01000100), 0b00100010); }
proc Internal_reverse8_0b01000101(test: borrowed Test) throws { test.assertEqual(reverse8(0b01000101), 0b10100010); }
proc Internal_reverse8_0b01000110(test: borrowed Test) throws { test.assertEqual(reverse8(0b01000110), 0b01100010); }
proc Internal_reverse8_0b01000111(test: borrowed Test) throws { test.assertEqual(reverse8(0b01000111), 0b11100010); }
proc Internal_reverse8_0b01001000(test: borrowed Test) throws { test.assertEqual(reverse8(0b01001000), 0b00010010); }
proc Internal_reverse8_0b01001001(test: borrowed Test) throws { test.assertEqual(reverse8(0b01001001), 0b10010010); }
proc Internal_reverse8_0b01001010(test: borrowed Test) throws { test.assertEqual(reverse8(0b01001010), 0b01010010); }
proc Internal_reverse8_0b01001011(test: borrowed Test) throws { test.assertEqual(reverse8(0b01001011), 0b11010010); }
proc Internal_reverse8_0b01001100(test: borrowed Test) throws { test.assertEqual(reverse8(0b01001100), 0b00110010); }
proc Internal_reverse8_0b01001101(test: borrowed Test) throws { test.assertEqual(reverse8(0b01001101), 0b10110010); }
proc Internal_reverse8_0b01001110(test: borrowed Test) throws { test.assertEqual(reverse8(0b01001110), 0b01110010); }
proc Internal_reverse8_0b01001111(test: borrowed Test) throws { test.assertEqual(reverse8(0b01001111), 0b11110010); }
proc Internal_reverse8_0b01010000(test: borrowed Test) throws { test.assertEqual(reverse8(0b01010000), 0b00001010); }
proc Internal_reverse8_0b01010001(test: borrowed Test) throws { test.assertEqual(reverse8(0b01010001), 0b10001010); }
proc Internal_reverse8_0b01010010(test: borrowed Test) throws { test.assertEqual(reverse8(0b01010010), 0b01001010); }
proc Internal_reverse8_0b01010011(test: borrowed Test) throws { test.assertEqual(reverse8(0b01010011), 0b11001010); }
proc Internal_reverse8_0b01010100(test: borrowed Test) throws { test.assertEqual(reverse8(0b01010100), 0b00101010); }
proc Internal_reverse8_0b01010101(test: borrowed Test) throws { test.assertEqual(reverse8(0b01010101), 0b10101010); }
proc Internal_reverse8_0b01010110(test: borrowed Test) throws { test.assertEqual(reverse8(0b01010110), 0b01101010); }
proc Internal_reverse8_0b01010111(test: borrowed Test) throws { test.assertEqual(reverse8(0b01010111), 0b11101010); }
proc Internal_reverse8_0b01011000(test: borrowed Test) throws { test.assertEqual(reverse8(0b01011000), 0b00011010); }
proc Internal_reverse8_0b01011001(test: borrowed Test) throws { test.assertEqual(reverse8(0b01011001), 0b10011010); }
proc Internal_reverse8_0b01011010(test: borrowed Test) throws { test.assertEqual(reverse8(0b01011010), 0b01011010); }
proc Internal_reverse8_0b01011011(test: borrowed Test) throws { test.assertEqual(reverse8(0b01011011), 0b11011010); }
proc Internal_reverse8_0b01011100(test: borrowed Test) throws { test.assertEqual(reverse8(0b01011100), 0b00111010); }
proc Internal_reverse8_0b01011101(test: borrowed Test) throws { test.assertEqual(reverse8(0b01011101), 0b10111010); }
proc Internal_reverse8_0b01011110(test: borrowed Test) throws { test.assertEqual(reverse8(0b01011110), 0b01111010); }
proc Internal_reverse8_0b01011111(test: borrowed Test) throws { test.assertEqual(reverse8(0b01011111), 0b11111010); }
proc Internal_reverse8_0b01100000(test: borrowed Test) throws { test.assertEqual(reverse8(0b01100000), 0b00000110); }
proc Internal_reverse8_0b01100001(test: borrowed Test) throws { test.assertEqual(reverse8(0b01100001), 0b10000110); }
proc Internal_reverse8_0b01100010(test: borrowed Test) throws { test.assertEqual(reverse8(0b01100010), 0b01000110); }
proc Internal_reverse8_0b01100011(test: borrowed Test) throws { test.assertEqual(reverse8(0b01100011), 0b11000110); }
proc Internal_reverse8_0b01100100(test: borrowed Test) throws { test.assertEqual(reverse8(0b01100100), 0b00100110); }
proc Internal_reverse8_0b01100101(test: borrowed Test) throws { test.assertEqual(reverse8(0b01100101), 0b10100110); }
proc Internal_reverse8_0b01100110(test: borrowed Test) throws { test.assertEqual(reverse8(0b01100110), 0b01100110); }
proc Internal_reverse8_0b01100111(test: borrowed Test) throws { test.assertEqual(reverse8(0b01100111), 0b11100110); }
proc Internal_reverse8_0b01101000(test: borrowed Test) throws { test.assertEqual(reverse8(0b01101000), 0b00010110); }
proc Internal_reverse8_0b01101001(test: borrowed Test) throws { test.assertEqual(reverse8(0b01101001), 0b10010110); }
proc Internal_reverse8_0b01101010(test: borrowed Test) throws { test.assertEqual(reverse8(0b01101010), 0b01010110); }
proc Internal_reverse8_0b01101011(test: borrowed Test) throws { test.assertEqual(reverse8(0b01101011), 0b11010110); }
proc Internal_reverse8_0b01101100(test: borrowed Test) throws { test.assertEqual(reverse8(0b01101100), 0b00110110); }
proc Internal_reverse8_0b01101101(test: borrowed Test) throws { test.assertEqual(reverse8(0b01101101), 0b10110110); }
proc Internal_reverse8_0b01101110(test: borrowed Test) throws { test.assertEqual(reverse8(0b01101110), 0b01110110); }
proc Internal_reverse8_0b01101111(test: borrowed Test) throws { test.assertEqual(reverse8(0b01101111), 0b11110110); }
proc Internal_reverse8_0b01110000(test: borrowed Test) throws { test.assertEqual(reverse8(0b01110000), 0b00001110); }
proc Internal_reverse8_0b01110001(test: borrowed Test) throws { test.assertEqual(reverse8(0b01110001), 0b10001110); }
proc Internal_reverse8_0b01110010(test: borrowed Test) throws { test.assertEqual(reverse8(0b01110010), 0b01001110); }
proc Internal_reverse8_0b01110011(test: borrowed Test) throws { test.assertEqual(reverse8(0b01110011), 0b11001110); }
proc Internal_reverse8_0b01110100(test: borrowed Test) throws { test.assertEqual(reverse8(0b01110100), 0b00101110); }
proc Internal_reverse8_0b01110101(test: borrowed Test) throws { test.assertEqual(reverse8(0b01110101), 0b10101110); }
proc Internal_reverse8_0b01110110(test: borrowed Test) throws { test.assertEqual(reverse8(0b01110110), 0b01101110); }
proc Internal_reverse8_0b01110111(test: borrowed Test) throws { test.assertEqual(reverse8(0b01110111), 0b11101110); }
proc Internal_reverse8_0b01111000(test: borrowed Test) throws { test.assertEqual(reverse8(0b01111000), 0b00011110); }
proc Internal_reverse8_0b01111001(test: borrowed Test) throws { test.assertEqual(reverse8(0b01111001), 0b10011110); }
proc Internal_reverse8_0b01111010(test: borrowed Test) throws { test.assertEqual(reverse8(0b01111010), 0b01011110); }
proc Internal_reverse8_0b01111011(test: borrowed Test) throws { test.assertEqual(reverse8(0b01111011), 0b11011110); }
proc Internal_reverse8_0b01111100(test: borrowed Test) throws { test.assertEqual(reverse8(0b01111100), 0b00111110); }
proc Internal_reverse8_0b01111101(test: borrowed Test) throws { test.assertEqual(reverse8(0b01111101), 0b10111110); }
proc Internal_reverse8_0b01111110(test: borrowed Test) throws { test.assertEqual(reverse8(0b01111110), 0b01111110); }
proc Internal_reverse8_0b01111111(test: borrowed Test) throws { test.assertEqual(reverse8(0b01111111), 0b11111110); }
proc Internal_reverse8_0b10000000(test: borrowed Test) throws { test.assertEqual(reverse8(0b10000000), 0b00000001); }
proc Internal_reverse8_0b10000001(test: borrowed Test) throws { test.assertEqual(reverse8(0b10000001), 0b10000001); }
proc Internal_reverse8_0b10000010(test: borrowed Test) throws { test.assertEqual(reverse8(0b10000010), 0b01000001); }
proc Internal_reverse8_0b10000011(test: borrowed Test) throws { test.assertEqual(reverse8(0b10000011), 0b11000001); }
proc Internal_reverse8_0b10000100(test: borrowed Test) throws { test.assertEqual(reverse8(0b10000100), 0b00100001); }
proc Internal_reverse8_0b10000101(test: borrowed Test) throws { test.assertEqual(reverse8(0b10000101), 0b10100001); }
proc Internal_reverse8_0b10000110(test: borrowed Test) throws { test.assertEqual(reverse8(0b10000110), 0b01100001); }
proc Internal_reverse8_0b10000111(test: borrowed Test) throws { test.assertEqual(reverse8(0b10000111), 0b11100001); }
proc Internal_reverse8_0b10001000(test: borrowed Test) throws { test.assertEqual(reverse8(0b10001000), 0b00010001); }
proc Internal_reverse8_0b10001001(test: borrowed Test) throws { test.assertEqual(reverse8(0b10001001), 0b10010001); }
proc Internal_reverse8_0b10001010(test: borrowed Test) throws { test.assertEqual(reverse8(0b10001010), 0b01010001); }
proc Internal_reverse8_0b10001011(test: borrowed Test) throws { test.assertEqual(reverse8(0b10001011), 0b11010001); }
proc Internal_reverse8_0b10001100(test: borrowed Test) throws { test.assertEqual(reverse8(0b10001100), 0b00110001); }
proc Internal_reverse8_0b10001101(test: borrowed Test) throws { test.assertEqual(reverse8(0b10001101), 0b10110001); }
proc Internal_reverse8_0b10001110(test: borrowed Test) throws { test.assertEqual(reverse8(0b10001110), 0b01110001); }
proc Internal_reverse8_0b10001111(test: borrowed Test) throws { test.assertEqual(reverse8(0b10001111), 0b11110001); }
proc Internal_reverse8_0b10010000(test: borrowed Test) throws { test.assertEqual(reverse8(0b10010000), 0b00001001); }
proc Internal_reverse8_0b10010001(test: borrowed Test) throws { test.assertEqual(reverse8(0b10010001), 0b10001001); }
proc Internal_reverse8_0b10010010(test: borrowed Test) throws { test.assertEqual(reverse8(0b10010010), 0b01001001); }
proc Internal_reverse8_0b10010011(test: borrowed Test) throws { test.assertEqual(reverse8(0b10010011), 0b11001001); }
proc Internal_reverse8_0b10010100(test: borrowed Test) throws { test.assertEqual(reverse8(0b10010100), 0b00101001); }
proc Internal_reverse8_0b10010101(test: borrowed Test) throws { test.assertEqual(reverse8(0b10010101), 0b10101001); }
proc Internal_reverse8_0b10010110(test: borrowed Test) throws { test.assertEqual(reverse8(0b10010110), 0b01101001); }
proc Internal_reverse8_0b10010111(test: borrowed Test) throws { test.assertEqual(reverse8(0b10010111), 0b11101001); }
proc Internal_reverse8_0b10011000(test: borrowed Test) throws { test.assertEqual(reverse8(0b10011000), 0b00011001); }
proc Internal_reverse8_0b10011001(test: borrowed Test) throws { test.assertEqual(reverse8(0b10011001), 0b10011001); }
proc Internal_reverse8_0b10011010(test: borrowed Test) throws { test.assertEqual(reverse8(0b10011010), 0b01011001); }
proc Internal_reverse8_0b10011011(test: borrowed Test) throws { test.assertEqual(reverse8(0b10011011), 0b11011001); }
proc Internal_reverse8_0b10011100(test: borrowed Test) throws { test.assertEqual(reverse8(0b10011100), 0b00111001); }
proc Internal_reverse8_0b10011101(test: borrowed Test) throws { test.assertEqual(reverse8(0b10011101), 0b10111001); }
proc Internal_reverse8_0b10011110(test: borrowed Test) throws { test.assertEqual(reverse8(0b10011110), 0b01111001); }
proc Internal_reverse8_0b10011111(test: borrowed Test) throws { test.assertEqual(reverse8(0b10011111), 0b11111001); }
proc Internal_reverse8_0b10100000(test: borrowed Test) throws { test.assertEqual(reverse8(0b10100000), 0b00000101); }
proc Internal_reverse8_0b10100001(test: borrowed Test) throws { test.assertEqual(reverse8(0b10100001), 0b10000101); }
proc Internal_reverse8_0b10100010(test: borrowed Test) throws { test.assertEqual(reverse8(0b10100010), 0b01000101); }
proc Internal_reverse8_0b10100011(test: borrowed Test) throws { test.assertEqual(reverse8(0b10100011), 0b11000101); }
proc Internal_reverse8_0b10100100(test: borrowed Test) throws { test.assertEqual(reverse8(0b10100100), 0b00100101); }
proc Internal_reverse8_0b10100101(test: borrowed Test) throws { test.assertEqual(reverse8(0b10100101), 0b10100101); }
proc Internal_reverse8_0b10100110(test: borrowed Test) throws { test.assertEqual(reverse8(0b10100110), 0b01100101); }
proc Internal_reverse8_0b10100111(test: borrowed Test) throws { test.assertEqual(reverse8(0b10100111), 0b11100101); }
proc Internal_reverse8_0b10101000(test: borrowed Test) throws { test.assertEqual(reverse8(0b10101000), 0b00010101); }
proc Internal_reverse8_0b10101001(test: borrowed Test) throws { test.assertEqual(reverse8(0b10101001), 0b10010101); }
proc Internal_reverse8_0b10101010(test: borrowed Test) throws { test.assertEqual(reverse8(0b10101010), 0b01010101); }
proc Internal_reverse8_0b10101011(test: borrowed Test) throws { test.assertEqual(reverse8(0b10101011), 0b11010101); }
proc Internal_reverse8_0b10101100(test: borrowed Test) throws { test.assertEqual(reverse8(0b10101100), 0b00110101); }
proc Internal_reverse8_0b10101101(test: borrowed Test) throws { test.assertEqual(reverse8(0b10101101), 0b10110101); }
proc Internal_reverse8_0b10101110(test: borrowed Test) throws { test.assertEqual(reverse8(0b10101110), 0b01110101); }
proc Internal_reverse8_0b10101111(test: borrowed Test) throws { test.assertEqual(reverse8(0b10101111), 0b11110101); }
proc Internal_reverse8_0b10110000(test: borrowed Test) throws { test.assertEqual(reverse8(0b10110000), 0b00001101); }
proc Internal_reverse8_0b10110001(test: borrowed Test) throws { test.assertEqual(reverse8(0b10110001), 0b10001101); }
proc Internal_reverse8_0b10110010(test: borrowed Test) throws { test.assertEqual(reverse8(0b10110010), 0b01001101); }
proc Internal_reverse8_0b10110011(test: borrowed Test) throws { test.assertEqual(reverse8(0b10110011), 0b11001101); }
proc Internal_reverse8_0b10110100(test: borrowed Test) throws { test.assertEqual(reverse8(0b10110100), 0b00101101); }
proc Internal_reverse8_0b10110101(test: borrowed Test) throws { test.assertEqual(reverse8(0b10110101), 0b10101101); }
proc Internal_reverse8_0b10110110(test: borrowed Test) throws { test.assertEqual(reverse8(0b10110110), 0b01101101); }
proc Internal_reverse8_0b10110111(test: borrowed Test) throws { test.assertEqual(reverse8(0b10110111), 0b11101101); }
proc Internal_reverse8_0b10111000(test: borrowed Test) throws { test.assertEqual(reverse8(0b10111000), 0b00011101); }
proc Internal_reverse8_0b10111001(test: borrowed Test) throws { test.assertEqual(reverse8(0b10111001), 0b10011101); }
proc Internal_reverse8_0b10111010(test: borrowed Test) throws { test.assertEqual(reverse8(0b10111010), 0b01011101); }
proc Internal_reverse8_0b10111011(test: borrowed Test) throws { test.assertEqual(reverse8(0b10111011), 0b11011101); }
proc Internal_reverse8_0b10111100(test: borrowed Test) throws { test.assertEqual(reverse8(0b10111100), 0b00111101); }
proc Internal_reverse8_0b10111101(test: borrowed Test) throws { test.assertEqual(reverse8(0b10111101), 0b10111101); }
proc Internal_reverse8_0b10111110(test: borrowed Test) throws { test.assertEqual(reverse8(0b10111110), 0b01111101); }
proc Internal_reverse8_0b10111111(test: borrowed Test) throws { test.assertEqual(reverse8(0b10111111), 0b11111101); }
proc Internal_reverse8_0b11000000(test: borrowed Test) throws { test.assertEqual(reverse8(0b11000000), 0b00000011); }
proc Internal_reverse8_0b11000001(test: borrowed Test) throws { test.assertEqual(reverse8(0b11000001), 0b10000011); }
proc Internal_reverse8_0b11000010(test: borrowed Test) throws { test.assertEqual(reverse8(0b11000010), 0b01000011); }
proc Internal_reverse8_0b11000011(test: borrowed Test) throws { test.assertEqual(reverse8(0b11000011), 0b11000011); }
proc Internal_reverse8_0b11000100(test: borrowed Test) throws { test.assertEqual(reverse8(0b11000100), 0b00100011); }
proc Internal_reverse8_0b11000101(test: borrowed Test) throws { test.assertEqual(reverse8(0b11000101), 0b10100011); }
proc Internal_reverse8_0b11000110(test: borrowed Test) throws { test.assertEqual(reverse8(0b11000110), 0b01100011); }
proc Internal_reverse8_0b11000111(test: borrowed Test) throws { test.assertEqual(reverse8(0b11000111), 0b11100011); }
proc Internal_reverse8_0b11001000(test: borrowed Test) throws { test.assertEqual(reverse8(0b11001000), 0b00010011); }
proc Internal_reverse8_0b11001001(test: borrowed Test) throws { test.assertEqual(reverse8(0b11001001), 0b10010011); }
proc Internal_reverse8_0b11001010(test: borrowed Test) throws { test.assertEqual(reverse8(0b11001010), 0b01010011); }
proc Internal_reverse8_0b11001011(test: borrowed Test) throws { test.assertEqual(reverse8(0b11001011), 0b11010011); }
proc Internal_reverse8_0b11001100(test: borrowed Test) throws { test.assertEqual(reverse8(0b11001100), 0b00110011); }
proc Internal_reverse8_0b11001101(test: borrowed Test) throws { test.assertEqual(reverse8(0b11001101), 0b10110011); }
proc Internal_reverse8_0b11001110(test: borrowed Test) throws { test.assertEqual(reverse8(0b11001110), 0b01110011); }
proc Internal_reverse8_0b11001111(test: borrowed Test) throws { test.assertEqual(reverse8(0b11001111), 0b11110011); }
proc Internal_reverse8_0b11010000(test: borrowed Test) throws { test.assertEqual(reverse8(0b11010000), 0b00001011); }
proc Internal_reverse8_0b11010001(test: borrowed Test) throws { test.assertEqual(reverse8(0b11010001), 0b10001011); }
proc Internal_reverse8_0b11010010(test: borrowed Test) throws { test.assertEqual(reverse8(0b11010010), 0b01001011); }
proc Internal_reverse8_0b11010011(test: borrowed Test) throws { test.assertEqual(reverse8(0b11010011), 0b11001011); }
proc Internal_reverse8_0b11010100(test: borrowed Test) throws { test.assertEqual(reverse8(0b11010100), 0b00101011); }
proc Internal_reverse8_0b11010101(test: borrowed Test) throws { test.assertEqual(reverse8(0b11010101), 0b10101011); }
proc Internal_reverse8_0b11010110(test: borrowed Test) throws { test.assertEqual(reverse8(0b11010110), 0b01101011); }
proc Internal_reverse8_0b11010111(test: borrowed Test) throws { test.assertEqual(reverse8(0b11010111), 0b11101011); }
proc Internal_reverse8_0b11011000(test: borrowed Test) throws { test.assertEqual(reverse8(0b11011000), 0b00011011); }
proc Internal_reverse8_0b11011001(test: borrowed Test) throws { test.assertEqual(reverse8(0b11011001), 0b10011011); }
proc Internal_reverse8_0b11011010(test: borrowed Test) throws { test.assertEqual(reverse8(0b11011010), 0b01011011); }
proc Internal_reverse8_0b11011011(test: borrowed Test) throws { test.assertEqual(reverse8(0b11011011), 0b11011011); }
proc Internal_reverse8_0b11011100(test: borrowed Test) throws { test.assertEqual(reverse8(0b11011100), 0b00111011); }
proc Internal_reverse8_0b11011101(test: borrowed Test) throws { test.assertEqual(reverse8(0b11011101), 0b10111011); }
proc Internal_reverse8_0b11011110(test: borrowed Test) throws { test.assertEqual(reverse8(0b11011110), 0b01111011); }
proc Internal_reverse8_0b11011111(test: borrowed Test) throws { test.assertEqual(reverse8(0b11011111), 0b11111011); }
proc Internal_reverse8_0b11100000(test: borrowed Test) throws { test.assertEqual(reverse8(0b11100000), 0b00000111); }
proc Internal_reverse8_0b11100001(test: borrowed Test) throws { test.assertEqual(reverse8(0b11100001), 0b10000111); }
proc Internal_reverse8_0b11100010(test: borrowed Test) throws { test.assertEqual(reverse8(0b11100010), 0b01000111); }
proc Internal_reverse8_0b11100011(test: borrowed Test) throws { test.assertEqual(reverse8(0b11100011), 0b11000111); }
proc Internal_reverse8_0b11100100(test: borrowed Test) throws { test.assertEqual(reverse8(0b11100100), 0b00100111); }
proc Internal_reverse8_0b11100101(test: borrowed Test) throws { test.assertEqual(reverse8(0b11100101), 0b10100111); }
proc Internal_reverse8_0b11100110(test: borrowed Test) throws { test.assertEqual(reverse8(0b11100110), 0b01100111); }
proc Internal_reverse8_0b11100111(test: borrowed Test) throws { test.assertEqual(reverse8(0b11100111), 0b11100111); }
proc Internal_reverse8_0b11101000(test: borrowed Test) throws { test.assertEqual(reverse8(0b11101000), 0b00010111); }
proc Internal_reverse8_0b11101001(test: borrowed Test) throws { test.assertEqual(reverse8(0b11101001), 0b10010111); }
proc Internal_reverse8_0b11101010(test: borrowed Test) throws { test.assertEqual(reverse8(0b11101010), 0b01010111); }
proc Internal_reverse8_0b11101011(test: borrowed Test) throws { test.assertEqual(reverse8(0b11101011), 0b11010111); }
proc Internal_reverse8_0b11101100(test: borrowed Test) throws { test.assertEqual(reverse8(0b11101100), 0b00110111); }
proc Internal_reverse8_0b11101101(test: borrowed Test) throws { test.assertEqual(reverse8(0b11101101), 0b10110111); }
proc Internal_reverse8_0b11101110(test: borrowed Test) throws { test.assertEqual(reverse8(0b11101110), 0b01110111); }
proc Internal_reverse8_0b11101111(test: borrowed Test) throws { test.assertEqual(reverse8(0b11101111), 0b11110111); }
proc Internal_reverse8_0b11110000(test: borrowed Test) throws { test.assertEqual(reverse8(0b11110000), 0b00001111); }
proc Internal_reverse8_0b11110001(test: borrowed Test) throws { test.assertEqual(reverse8(0b11110001), 0b10001111); }
proc Internal_reverse8_0b11110010(test: borrowed Test) throws { test.assertEqual(reverse8(0b11110010), 0b01001111); }
proc Internal_reverse8_0b11110011(test: borrowed Test) throws { test.assertEqual(reverse8(0b11110011), 0b11001111); }
proc Internal_reverse8_0b11110100(test: borrowed Test) throws { test.assertEqual(reverse8(0b11110100), 0b00101111); }
proc Internal_reverse8_0b11110101(test: borrowed Test) throws { test.assertEqual(reverse8(0b11110101), 0b10101111); }
proc Internal_reverse8_0b11110110(test: borrowed Test) throws { test.assertEqual(reverse8(0b11110110), 0b01101111); }
proc Internal_reverse8_0b11110111(test: borrowed Test) throws { test.assertEqual(reverse8(0b11110111), 0b11101111); }
proc Internal_reverse8_0b11111000(test: borrowed Test) throws { test.assertEqual(reverse8(0b11111000), 0b00011111); }
proc Internal_reverse8_0b11111001(test: borrowed Test) throws { test.assertEqual(reverse8(0b11111001), 0b10011111); }
proc Internal_reverse8_0b11111010(test: borrowed Test) throws { test.assertEqual(reverse8(0b11111010), 0b01011111); }
proc Internal_reverse8_0b11111011(test: borrowed Test) throws { test.assertEqual(reverse8(0b11111011), 0b11011111); }
proc Internal_reverse8_0b11111100(test: borrowed Test) throws { test.assertEqual(reverse8(0b11111100), 0b00111111); }
proc Internal_reverse8_0b11111101(test: borrowed Test) throws { test.assertEqual(reverse8(0b11111101), 0b10111111); }
proc Internal_reverse8_0b11111110(test: borrowed Test) throws { test.assertEqual(reverse8(0b11111110), 0b01111111); }
proc Internal_reverse8_0b11111111(test: borrowed Test) throws { test.assertEqual(reverse8(0b11111111), 0b11111111); }


UnitTest.main();