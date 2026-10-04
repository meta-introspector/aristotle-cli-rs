import Mathlib

set_option pp.all true
-- spec: String.Slice.rawEndPos : String.Slice -> String.Pos.Raw
def String.Slice.rawEndPos : String.Slice -> String.Pos.Raw :=
  fun (s : String.Slice) => String.Pos.Raw.mk (String.Slice.utf8ByteSize s)
