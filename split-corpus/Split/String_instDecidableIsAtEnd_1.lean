import Mathlib

set_option pp.all true
-- spec: String.instDecidableIsAtEnd_1 : forall {s : String.Slice} {pos : String.Slice.Pos s}, Decidable (String.Slice.Pos.IsAtEnd s pos)
def String.instDecidableIsAtEnd_1 : forall {s : String.Slice} {pos : String.Slice.Pos s}, Decidable (String.Slice.Pos.IsAtEnd s pos) :=
  fun {s : String.Slice} {pos : String.Slice.Pos s} => decidable_of_iff (String.Slice.Pos.IsAtEnd s pos) (String.Slice.Pos.IsAtEnd s pos) (String.Slice.Pos.isAtEnd_iff s pos) (String.Slice.instDecidableEqPos s pos (String.Slice.endPos s))
