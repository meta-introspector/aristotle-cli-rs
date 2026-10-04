import Mathlib

set_option pp.all true
-- spec: String.rawEndPos : String -> String.Pos.Raw
def String.rawEndPos : String -> String.Pos.Raw :=
  fun (s : String) => String.Pos.Raw.mk (String.utf8ByteSize s)
