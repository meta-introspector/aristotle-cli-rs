import Mathlib

set_option pp.all true
-- spec: String.Slice.Pos.IsAtEnd : forall {s : String.Slice}, (String.Slice.Pos s) -> Prop
def String.Slice.Pos.IsAtEnd : forall {s : String.Slice}, (String.Slice.Pos s) -> Prop :=
  fun {s : String.Slice} (pos : String.Slice.Pos s) => Eq.{1} (String.Slice.Pos s) pos (String.Slice.endPos s)
