import Mathlib

set_option pp.all true
-- spec: String.startPos : forall (s : String), String.Pos s
def String.startPos : forall (s : String), String.Pos s :=
  fun (s : String) => String.Pos.mk s (OfNat.ofNat.{0} String.Pos.Raw 0 String.instOfNatRaw) (String.startPos._proof_1 s)
