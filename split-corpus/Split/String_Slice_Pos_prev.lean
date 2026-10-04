import Mathlib

set_option pp.all true
-- spec: String.Slice.Pos.prev : forall {s : String.Slice} (pos : String.Slice.Pos s), (Ne.{1} (String.Slice.Pos s) pos (String.Slice.startPos s)) -> (String.Slice.Pos s)
def String.Slice.Pos.prev : forall {s : String.Slice} (pos : String.Slice.Pos s), (Ne.{1} (String.Slice.Pos s) pos (String.Slice.startPos s)) -> (String.Slice.Pos s) :=
  fun {s : String.Slice} (pos : String.Slice.Pos s) (h : Ne.{1} (String.Slice.Pos s) pos (String.Slice.startPos s)) => String.Slice.posLT s (String.Slice.Pos.offset s pos) (String.Slice.Pos.prev._proof_3 s pos h)
