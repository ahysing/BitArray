module Errors {
  /* Exception thrown when indexing the bit arrays outside the range of values the bit array */
  class BitRangeError : IllegalArgumentError {
    proc init() {
      super.init("idx is out of range");
    }
  }
}