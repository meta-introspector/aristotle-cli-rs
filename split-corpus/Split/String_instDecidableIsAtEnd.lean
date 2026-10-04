import Mathlib

set_option pp.all true
-- spec: String.instDecidableIsAtEnd : forall {s : String} {pos : String.Pos s}, Decidable (String.Pos.IsAtEnd s pos)
def String.instDecidableIsAtEnd : forall {s : String} {pos : String.Pos s}, Decidable (String.Pos.IsAtEnd s pos) :=
  fun {s : String} {pos : String.Pos s} => decidable_of_iff (String.Pos.IsAtEnd s pos) (String.Pos.IsAtEnd s pos) (String.Pos.isAtEnd_iff s pos) (String.instDecidableEqPos s pos (String.endPos s))
