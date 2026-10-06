import Mathlib

set_option pp.all true
-- spec: String.toSlice : String -> String.Slice
def String.toSlice : String -> String.Slice :=
  fun (s : String) => String.Slice.mk s (String.startPos s) (String.endPos s) (String.toSlice._proof_2 s)
