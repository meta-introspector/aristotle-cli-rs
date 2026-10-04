import Mathlib

set_option pp.all true
-- spec: String.Pos.ofToSlice : forall {s : String}, (String.Slice.Pos (String.toSlice s)) -> (String.Pos s)
def String.Pos.ofToSlice : forall {s : String}, (String.Slice.Pos (String.toSlice s)) -> (String.Pos s) :=
  fun {s : String} (pos : String.Slice.Pos (String.toSlice s)) => String.Pos.mk s (String.Slice.Pos.offset (String.toSlice s) pos) (String.Pos.ofToSlice._proof_1 s pos)
