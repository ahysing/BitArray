module Errors {
  /* Exception thrown when indexing outside the range of values the bit array */
  class BitRangeError : IllegalArgumentError {
    proc init() {
      super.init("idx is out of range");
    }
  }

  /* Exception thrown when bitshifting outside the range of values the bit array */
  class ShiftRangeError : IllegalArgumentError {
    proc init() {
      super.init("shift is out of range");
    }
  }
}