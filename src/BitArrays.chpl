/* BitArrays is a library for effective storage of boolean values in arrays. */
module BitArrays {
    // Note to self: https://chapel-lang.org/docs/technotes/module_include.html?highlight=modules
    include module BitArrays32;
    include module BitArrays64;
    include private module Internal;
}