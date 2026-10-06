import Mathlib

set_option pp.all true
-- spec: String.instOfNatRaw : OfNat.{0} String.Pos.Raw 0
def String.instOfNatRaw : OfNat.{0} String.Pos.Raw 0 :=
  OfNat.mk.{0} String.Pos.Raw 0 (String.Pos.Raw.mk (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))
