/* BitArrays is a library for effective compact of boolean values.
   The classes provided comes with  fast set operations such and, or, not minus.
*/
module BitArrays {
  // Note to self: https://chapel-lang.org/docs/technotes/module_include.html?highlight=modules
  include module BitArrays32;
  public import this.BitArrays32;
  include module BitArrays64;
  public import this.BitArrays64;
  include module Errors;
  public import this.Errors;
  include module Internal;
  public import this.Internal;
}