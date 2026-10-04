import Mathlib

set_option pp.all true
-- spec: String.Pos.toSlice : forall {s : String}, (String.Pos s) -> (String.Slice.Pos (String.toSlice s))
def String.Pos.toSlice : forall {s : String}, (String.Pos s) -> (String.Slice.Pos (String.toSlice s)) :=
  fun {s : String} (pos : String.Pos s) => String.Slice.Pos.mk (String.toSlice s) (String.Pos.offset s pos) (String.Pos.toSlice._proof_1 s pos)
