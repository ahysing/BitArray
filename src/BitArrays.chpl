/* BitArrays is a library for effective storage of boolean values in arrays. */
module BitArrays {
    // Note to self: https://chapel-lang.org/docs/technotes/module_include.html?highlight=modules
    include module BitArrays32;
    public import this.BitArrays32;
    include module BitArrays64;
    public import this.BitArrays64;

    include module Internal;
    public import this.Internal;
}