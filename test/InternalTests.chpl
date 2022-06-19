use UnitTest;
use BitArrays.Internal;

proc Internal_unsignedAll_inputIs128Bits_valuesAreTrue(test: borrowed Test) throws {
  const size = 128;
  const packSize = 64;
  var values = [~0 : uint(64), ~0 : uint(64)];
  var result = unsignedAll(false, packSize, size, values);

  test.assertTrue(result);
}

proc Internal_unsignedAll_inputIs65Bits_valuesAreTrue(test: borrowed Test) throws {
  const size = 64;
  const packSize = 64;
  const hasRemaining = size % packSize == 0;
  var values = [~0 : uint(64), 0b1 : uint(64)];
  var result = unsignedAll(hasRemaining, packSize, size, values);
  test.assertTrue(result);
}

proc Internal_unsignedAll_inputIs127Bits_valuesAreTrue(test: borrowed Test) throws {
  const size = 127;
  const packSize = 64;
  const hasRemaining = size % packSize == 0;
  var values = [~0 : uint(64), 0x7FFFFFFFFFFFFFFF : uint(64)];
  var result = unsignedAll(hasRemaining, packSize, size, values);
  test.assertTrue(result);
}

proc Internal_unsignedAll_inputIs127Bits_valuesAreTrueInFirstBlock_valuesAreFalseInSecondBlock(test: borrowed Test) throws {
  const size = 127;
  const packSize = 64;
  const hasRemaining = size % packSize == 0;
  var values = [~0 : uint(64), ~0 : uint(64), 0 : uint(64)];
  var result = unsignedAll(hasRemaining, packSize, size, values);
  test.assertFalse(result);
}

proc Internal_unsignedAll_inputIs128Bits_valuesAreZeroThenOne(test: borrowed Test) throws {
  const size = 128;
  const packSize = 64;
  const hasRemaining = size % packSize == 0;
  var values = [~1 : uint(64), ~0 : uint(64)];
  var result = unsignedAll(hasRemaining, packSize, size, values);
  test.assertFalse(result);
}

proc Internal_unsignedAll_inputIs3Bits_valuesAreZeroThenOne(test: borrowed Test) throws {
  const size = 3;
  var values : [0..0]uint(64);
  const packSize = 64;
  const hasRemaining = size % packSize == 0;
  values[0] = 0b111 : uint(64);
  var result = unsignedAll(hasRemaining, packSize, size, values);
  test.assertTrue(result);
}

proc Internal_unsignedAll_inputIs66its_valuesAreZeroThenOne(test: borrowed Test) throws {
  const size = 65;
  const packSize = 64;
  const hasRemaining = size % packSize == 0;
  var values = [ 0xAAAAAAAAAAAAAAAA : uint(64), 0xA : uint(64)];
  var result = unsignedAll(hasRemaining, packSize, size, values);
  test.assertFalse(result);
}
// The following tests were made with a set of tests
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

proc Internal_reverse32_inputIs_1(test: borrowed Test) throws {
  test.assertEqual(reverse32(1 : uint(32)), 0b10000000000000000000000000000000 : uint(32));
}

proc Internal_reverse32_inputIs_2(test: borrowed Test) throws {
  test.assertEqual(reverse32(2 : uint(32)), 0b01000000000000000000000000000000 : uint(32));
}

proc BitArray32__reverseWord_inputIs_3(test: borrowed Test) throws {
  test.assertEqual(reverse32(3 : uint(32)), 0b11000000000000000000000000000000 : uint(32));
}

proc BitArray32__reverseWord_inputIs_100(test: borrowed Test) throws {
  test.assertEqual(reverse32(100 : uint(32)), 0b00100110000000000000000000000000 : uint(32));
}



/*
#!/bin/bash
for i in $(seq -f '%1.0f' 1 21474836 2147483647)
do
    x=$(printf "ibase=10;obase=2;%d\n" $i | bc)
    number=$(echo 00000000000000000000000000000000$x | tail -c 33)
    rev_number=$(echo $number | rev)
    echo "proc Internal_reverse32_0b${number}(test: borrowed Test) throws { test.assertEqual(reverse32(0b${number}), 0b${rev_number}); }"
done
*/

proc Internal_reverse32_0b00000000000000000000000000000001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00000000000000000000000000000001 : uint(32)), 0b10000000000000000000000000000000 : uint(32)); }
proc Internal_reverse32_0b00000001010001111010111000010101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00000001010001111010111000010101 : uint(32)), 0b10101000011101011110001010000000 : uint(32)); }
proc Internal_reverse32_0b00000010100011110101110000101001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00000010100011110101110000101001 : uint(32)), 0b10010100001110101111000101000000 : uint(32)); }
proc Internal_reverse32_0b00000011110101110000101000111101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00000011110101110000101000111101 : uint(32)), 0b10111100010100001110101111000000 : uint(32)); }
proc Internal_reverse32_0b00000101000111101011100001010001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00000101000111101011100001010001 : uint(32)), 0b10001010000111010111100010100000 : uint(32)); }
proc Internal_reverse32_0b00000110011001100110011001100101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00000110011001100110011001100101 : uint(32)), 0b10100110011001100110011001100000 : uint(32)); }
proc Internal_reverse32_0b00000111101011100001010001111001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00000111101011100001010001111001 : uint(32)), 0b10011110001010000111010111100000 : uint(32)); }
proc Internal_reverse32_0b00001000111101011100001010001101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00001000111101011100001010001101 : uint(32)), 0b10110001010000111010111100010000 : uint(32)); }
proc Internal_reverse32_0b00001010001111010111000010100001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00001010001111010111000010100001 : uint(32)), 0b10000101000011101011110001010000 : uint(32)); }
proc Internal_reverse32_0b00001011100001010001111010110101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00001011100001010001111010110101 : uint(32)), 0b10101101011110001010000111010000 : uint(32)); }
proc Internal_reverse32_0b00001100110011001100110011001001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00001100110011001100110011001001 : uint(32)), 0b10010011001100110011001100110000 : uint(32)); }
proc Internal_reverse32_0b00001110000101000111101011011101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00001110000101000111101011011101 : uint(32)), 0b10111011010111100010100001110000 : uint(32)); }
proc Internal_reverse32_0b00001111010111000010100011110001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00001111010111000010100011110001 : uint(32)), 0b10001111000101000011101011110000 : uint(32)); }
proc Internal_reverse32_0b00010000101000111101011100000101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00010000101000111101011100000101 : uint(32)), 0b10100000111010111100010100001000 : uint(32)); }
proc Internal_reverse32_0b00010001111010111000010100011001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00010001111010111000010100011001 : uint(32)), 0b10011000101000011101011110001000 : uint(32)); }
proc Internal_reverse32_0b00010011001100110011001100101101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00010011001100110011001100101101 : uint(32)), 0b10110100110011001100110011001000 : uint(32)); }
proc Internal_reverse32_0b00010100011110101110000101000001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00010100011110101110000101000001 : uint(32)), 0b10000010100001110101111000101000 : uint(32)); }
proc Internal_reverse32_0b00010101110000101000111101010101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00010101110000101000111101010101 : uint(32)), 0b10101010111100010100001110101000 : uint(32)); }
proc Internal_reverse32_0b00010111000010100011110101101001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00010111000010100011110101101001 : uint(32)), 0b10010110101111000101000011101000 : uint(32)); }
proc Internal_reverse32_0b00011000010100011110101101111101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00011000010100011110101101111101 : uint(32)), 0b10111110110101111000101000011000 : uint(32)); }
proc Internal_reverse32_0b00011001100110011001100110010001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00011001100110011001100110010001 : uint(32)), 0b10001001100110011001100110011000 : uint(32)); }
proc Internal_reverse32_0b00011010111000010100011110100101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00011010111000010100011110100101 : uint(32)), 0b10100101111000101000011101011000 : uint(32)); }
proc Internal_reverse32_0b00011100001010001111010110111001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00011100001010001111010110111001 : uint(32)), 0b10011101101011110001010000111000 : uint(32)); }
proc Internal_reverse32_0b00011101011100001010001111001101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00011101011100001010001111001101 : uint(32)), 0b10110011110001010000111010111000 : uint(32)); }
proc Internal_reverse32_0b00011110101110000101000111100001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00011110101110000101000111100001 : uint(32)), 0b10000111100010100001110101111000 : uint(32)); }
proc Internal_reverse32_0b00011111111111111111111111110101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00011111111111111111111111110101 : uint(32)), 0b10101111111111111111111111111000 : uint(32)); }
proc Internal_reverse32_0b00100001010001111010111000001001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00100001010001111010111000001001 : uint(32)), 0b10010000011101011110001010000100 : uint(32)); }
proc Internal_reverse32_0b00100010100011110101110000011101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00100010100011110101110000011101 : uint(32)), 0b10111000001110101111000101000100 : uint(32)); }
proc Internal_reverse32_0b00100011110101110000101000110001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00100011110101110000101000110001 : uint(32)), 0b10001100010100001110101111000100 : uint(32)); }
proc Internal_reverse32_0b00100101000111101011100001000101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00100101000111101011100001000101 : uint(32)), 0b10100010000111010111100010100100 : uint(32)); }
proc Internal_reverse32_0b00100110011001100110011001011001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00100110011001100110011001011001 : uint(32)), 0b10011010011001100110011001100100 : uint(32)); }
proc Internal_reverse32_0b00100111101011100001010001101101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00100111101011100001010001101101 : uint(32)), 0b10110110001010000111010111100100 : uint(32)); }
proc Internal_reverse32_0b00101000111101011100001010000001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00101000111101011100001010000001 : uint(32)), 0b10000001010000111010111100010100 : uint(32)); }
proc Internal_reverse32_0b00101010001111010111000010010101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00101010001111010111000010010101 : uint(32)), 0b10101001000011101011110001010100 : uint(32)); }
proc Internal_reverse32_0b00101011100001010001111010101001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00101011100001010001111010101001 : uint(32)), 0b10010101011110001010000111010100 : uint(32)); }
proc Internal_reverse32_0b00101100110011001100110010111101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00101100110011001100110010111101 : uint(32)), 0b10111101001100110011001100110100 : uint(32)); }
proc Internal_reverse32_0b00101110000101000111101011010001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00101110000101000111101011010001 : uint(32)), 0b10001011010111100010100001110100 : uint(32)); }
proc Internal_reverse32_0b00101111010111000010100011100101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00101111010111000010100011100101 : uint(32)), 0b10100111000101000011101011110100 : uint(32)); }
proc Internal_reverse32_0b00110000101000111101011011111001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00110000101000111101011011111001 : uint(32)), 0b10011111011010111100010100001100 : uint(32)); }
proc Internal_reverse32_0b00110001111010111000010100001101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00110001111010111000010100001101 : uint(32)), 0b10110000101000011101011110001100 : uint(32)); }
proc Internal_reverse32_0b00110011001100110011001100100001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00110011001100110011001100100001 : uint(32)), 0b10000100110011001100110011001100 : uint(32)); }
proc Internal_reverse32_0b00110100011110101110000100110101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00110100011110101110000100110101 : uint(32)), 0b10101100100001110101111000101100 : uint(32)); }
proc Internal_reverse32_0b00110101110000101000111101001001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00110101110000101000111101001001 : uint(32)), 0b10010010111100010100001110101100 : uint(32)); }
proc Internal_reverse32_0b00110111000010100011110101011101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00110111000010100011110101011101 : uint(32)), 0b10111010101111000101000011101100 : uint(32)); }
proc Internal_reverse32_0b00111000010100011110101101110001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00111000010100011110101101110001 : uint(32)), 0b10001110110101111000101000011100 : uint(32)); }
proc Internal_reverse32_0b00111001100110011001100110000101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00111001100110011001100110000101 : uint(32)), 0b10100001100110011001100110011100 : uint(32)); }
proc Internal_reverse32_0b00111010111000010100011110011001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00111010111000010100011110011001 : uint(32)), 0b10011001111000101000011101011100 : uint(32)); }
proc Internal_reverse32_0b00111100001010001111010110101101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00111100001010001111010110101101 : uint(32)), 0b10110101101011110001010000111100 : uint(32)); }
proc Internal_reverse32_0b00111101011100001010001111000001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00111101011100001010001111000001 : uint(32)), 0b10000011110001010000111010111100 : uint(32)); }
proc Internal_reverse32_0b00111110101110000101000111010101(test: borrowed Test) throws { test.assertEqual(reverse32(0b00111110101110000101000111010101 : uint(32)), 0b10101011100010100001110101111100 : uint(32)); }
proc Internal_reverse32_0b00111111111111111111111111101001(test: borrowed Test) throws { test.assertEqual(reverse32(0b00111111111111111111111111101001 : uint(32)), 0b10010111111111111111111111111100 : uint(32)); }
proc Internal_reverse32_0b01000001010001111010110111111101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01000001010001111010110111111101 : uint(32)), 0b10111111101101011110001010000010 : uint(32)); }
proc Internal_reverse32_0b01000010100011110101110000010001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01000010100011110101110000010001 : uint(32)), 0b10001000001110101111000101000010 : uint(32)); }
proc Internal_reverse32_0b01000011110101110000101000100101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01000011110101110000101000100101 : uint(32)), 0b10100100010100001110101111000010 : uint(32)); }
proc Internal_reverse32_0b01000101000111101011100000111001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01000101000111101011100000111001 : uint(32)), 0b10011100000111010111100010100010 : uint(32)); }
proc Internal_reverse32_0b01000110011001100110011001001101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01000110011001100110011001001101 : uint(32)), 0b10110010011001100110011001100010 : uint(32)); }
proc Internal_reverse32_0b01000111101011100001010001100001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01000111101011100001010001100001 : uint(32)), 0b10000110001010000111010111100010 : uint(32)); }
proc Internal_reverse32_0b01001000111101011100001001110101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01001000111101011100001001110101 : uint(32)), 0b10101110010000111010111100010010 : uint(32)); }
proc Internal_reverse32_0b01001010001111010111000010001001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01001010001111010111000010001001 : uint(32)), 0b10010001000011101011110001010010 : uint(32)); }
proc Internal_reverse32_0b01001011100001010001111010011101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01001011100001010001111010011101 : uint(32)), 0b10111001011110001010000111010010 : uint(32)); }
proc Internal_reverse32_0b01001100110011001100110010110001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01001100110011001100110010110001 : uint(32)), 0b10001101001100110011001100110010 : uint(32)); }
proc Internal_reverse32_0b01001110000101000111101011000101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01001110000101000111101011000101 : uint(32)), 0b10100011010111100010100001110010 : uint(32)); }
proc Internal_reverse32_0b01001111010111000010100011011001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01001111010111000010100011011001 : uint(32)), 0b10011011000101000011101011110010 : uint(32)); }
proc Internal_reverse32_0b01010000101000111101011011101101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01010000101000111101011011101101 : uint(32)), 0b10110111011010111100010100001010 : uint(32)); }
proc Internal_reverse32_0b01010001111010111000010100000001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01010001111010111000010100000001 : uint(32)), 0b10000000101000011101011110001010 : uint(32)); }
proc Internal_reverse32_0b01010011001100110011001100010101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01010011001100110011001100010101 : uint(32)), 0b10101000110011001100110011001010 : uint(32)); }
proc Internal_reverse32_0b01010100011110101110000100101001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01010100011110101110000100101001 : uint(32)), 0b10010100100001110101111000101010 : uint(32)); }
proc Internal_reverse32_0b01010101110000101000111100111101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01010101110000101000111100111101 : uint(32)), 0b10111100111100010100001110101010 : uint(32)); }
proc Internal_reverse32_0b01010111000010100011110101010001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01010111000010100011110101010001 : uint(32)), 0b10001010101111000101000011101010 : uint(32)); }
proc Internal_reverse32_0b01011000010100011110101101100101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01011000010100011110101101100101 : uint(32)), 0b10100110110101111000101000011010 : uint(32)); }
proc Internal_reverse32_0b01011001100110011001100101111001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01011001100110011001100101111001 : uint(32)), 0b10011110100110011001100110011010 : uint(32)); }
proc Internal_reverse32_0b01011010111000010100011110001101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01011010111000010100011110001101 : uint(32)), 0b10110001111000101000011101011010 : uint(32)); }
proc Internal_reverse32_0b01011100001010001111010110100001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01011100001010001111010110100001 : uint(32)), 0b10000101101011110001010000111010 : uint(32)); }
proc Internal_reverse32_0b01011101011100001010001110110101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01011101011100001010001110110101 : uint(32)), 0b10101101110001010000111010111010 : uint(32)); }
proc Internal_reverse32_0b01011110101110000101000111001001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01011110101110000101000111001001 : uint(32)), 0b10010011100010100001110101111010 : uint(32)); }
proc Internal_reverse32_0b01011111111111111111111111011101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01011111111111111111111111011101 : uint(32)), 0b10111011111111111111111111111010 : uint(32)); }
proc Internal_reverse32_0b01100001010001111010110111110001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01100001010001111010110111110001 : uint(32)), 0b10001111101101011110001010000110 : uint(32)); }
proc Internal_reverse32_0b01100010100011110101110000000101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01100010100011110101110000000101 : uint(32)), 0b10100000001110101111000101000110 : uint(32)); }
proc Internal_reverse32_0b01100011110101110000101000011001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01100011110101110000101000011001 : uint(32)), 0b10011000010100001110101111000110 : uint(32)); }
proc Internal_reverse32_0b01100101000111101011100000101101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01100101000111101011100000101101 : uint(32)), 0b10110100000111010111100010100110 : uint(32)); }
proc Internal_reverse32_0b01100110011001100110011001000001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01100110011001100110011001000001 : uint(32)), 0b10000010011001100110011001100110 : uint(32)); }
proc Internal_reverse32_0b01100111101011100001010001010101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01100111101011100001010001010101 : uint(32)), 0b10101010001010000111010111100110 : uint(32)); }
proc Internal_reverse32_0b01101000111101011100001001101001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01101000111101011100001001101001 : uint(32)), 0b10010110010000111010111100010110 : uint(32)); }
proc Internal_reverse32_0b01101010001111010111000001111101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01101010001111010111000001111101 : uint(32)), 0b10111110000011101011110001010110 : uint(32)); }
proc Internal_reverse32_0b01101011100001010001111010010001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01101011100001010001111010010001 : uint(32)), 0b10001001011110001010000111010110 : uint(32)); }
proc Internal_reverse32_0b01101100110011001100110010100101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01101100110011001100110010100101 : uint(32)), 0b10100101001100110011001100110110 : uint(32)); }
proc Internal_reverse32_0b01101110000101000111101010111001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01101110000101000111101010111001 : uint(32)), 0b10011101010111100010100001110110 : uint(32)); }
proc Internal_reverse32_0b01101111010111000010100011001101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01101111010111000010100011001101 : uint(32)), 0b10110011000101000011101011110110 : uint(32)); }
proc Internal_reverse32_0b01110000101000111101011011100001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01110000101000111101011011100001 : uint(32)), 0b10000111011010111100010100001110 : uint(32)); }
proc Internal_reverse32_0b01110001111010111000010011110101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01110001111010111000010011110101 : uint(32)), 0b10101111001000011101011110001110 : uint(32)); }
proc Internal_reverse32_0b01110011001100110011001100001001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01110011001100110011001100001001 : uint(32)), 0b10010000110011001100110011001110 : uint(32)); }
proc Internal_reverse32_0b01110100011110101110000100011101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01110100011110101110000100011101 : uint(32)), 0b10111000100001110101111000101110 : uint(32)); }
proc Internal_reverse32_0b01110101110000101000111100110001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01110101110000101000111100110001 : uint(32)), 0b10001100111100010100001110101110 : uint(32)); }
proc Internal_reverse32_0b01110111000010100011110101000101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01110111000010100011110101000101 : uint(32)), 0b10100010101111000101000011101110 : uint(32)); }
proc Internal_reverse32_0b01111000010100011110101101011001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01111000010100011110101101011001 : uint(32)), 0b10011010110101111000101000011110 : uint(32)); }
proc Internal_reverse32_0b01111001100110011001100101101101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01111001100110011001100101101101 : uint(32)), 0b10110110100110011001100110011110 : uint(32)); }
proc Internal_reverse32_0b01111010111000010100011110000001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01111010111000010100011110000001 : uint(32)), 0b10000001111000101000011101011110 : uint(32)); }
proc Internal_reverse32_0b01111100001010001111010110010101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01111100001010001111010110010101 : uint(32)), 0b10101001101011110001010000111110 : uint(32)); }
proc Internal_reverse32_0b01111101011100001010001110101001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01111101011100001010001110101001 : uint(32)), 0b10010101110001010000111010111110 : uint(32)); }
proc Internal_reverse32_0b01111110101110000101000110111101(test: borrowed Test) throws { test.assertEqual(reverse32(0b01111110101110000101000110111101 : uint(32)), 0b10111101100010100001110101111110 : uint(32)); }
proc Internal_reverse32_0b01111111111111111111111111010001(test: borrowed Test) throws { test.assertEqual(reverse32(0b01111111111111111111111111010001 : uint(32)), 0b10001011111111111111111111111110 : uint(32)); }

UnitTest.main();