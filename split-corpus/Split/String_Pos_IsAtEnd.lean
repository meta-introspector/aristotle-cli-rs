import Mathlib

set_option pp.all true
-- spec: String.Pos.IsAtEnd : forall {s : String}, (String.Pos s) -> Prop
def String.Pos.IsAtEnd : forall {s : String}, (String.Pos s) -> Prop :=
  fun {s : String} (pos : String.Pos s) => Eq.{1} (String.Pos s) pos (String.endPos s)
