module Errors {
  /* Exception thrown when indexing the bit arrays outside the range of values the bit array */
  class BitRangeError : IllegalArgumentError {
    proc init() {
      super.init("idx is out of range");
    }
  }

  /* Exception thrown when bitshifting the bit arrays outside the range of values the bit array */
  class ShiftRangeError : IllegalArgumentError {
    proc init() {
      super.init("shift is out of range");
    }
  }
}