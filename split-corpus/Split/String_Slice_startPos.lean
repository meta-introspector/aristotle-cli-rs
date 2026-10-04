import Mathlib

set_option pp.all true
-- spec: String.Slice.startPos : forall (s : String.Slice), String.Slice.Pos s
def String.Slice.startPos : forall (s : String.Slice), String.Slice.Pos s :=
  fun (s : String.Slice) => String.Slice.Pos.mk s (OfNat.ofNat.{0} String.Pos.Raw 0 String.instOfNatRaw) (String.Slice.startPos._proof_3 s)
