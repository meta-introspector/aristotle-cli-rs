import Mathlib

set_option pp.all true
-- spec: String.Slice.utf8ByteSize : String.Slice -> Nat
def String.Slice.utf8ByteSize : String.Slice -> Nat :=
  fun (s : String.Slice) => String.Pos.Raw.byteDistance (String.Pos.offset (String.Slice.str s) (String.Slice.startInclusive s)) (String.Pos.offset (String.Slice.str s) (String.Slice.endExclusive s))
