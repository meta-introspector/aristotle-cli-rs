import Mathlib

set_option pp.all true
-- spec: instInhabitedRaw : Inhabited.{1} String.Pos.Raw
def instInhabitedRaw : Inhabited.{1} String.Pos.Raw :=
  Inhabited.mk.{1} String.Pos.Raw (String.Pos.Raw.mk (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))
