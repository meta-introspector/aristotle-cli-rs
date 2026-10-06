import Mathlib

set_option pp.all true
-- spec: String.instDecidableIsValidForSlice : forall {s : String.Slice} {p : String.Pos.Raw}, Decidable (String.Pos.Raw.IsValidForSlice s p)
def String.instDecidableIsValidForSlice : forall {s : String.Slice} {p : String.Pos.Raw}, Decidable (String.Pos.Raw.IsValidForSlice s p) :=
  fun {s : String.Slice} {p : String.Pos.Raw} => decidable_of_iff (String.Pos.Raw.IsValidForSlice s p) (Eq.{1} Bool (String.Pos.Raw.isValidForSlice s p) Bool.true) (String.Pos.Raw.isValidForSlice_eq_true_iff s p) (instDecidableEqBool (String.Pos.Raw.isValidForSlice s p) Bool.true)
