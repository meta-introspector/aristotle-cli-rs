import Mathlib

set_option pp.all true
-- spec: instInhabitedFloat : Inhabited.{1} Float
def instInhabitedFloat : Inhabited.{1} Float :=
  Inhabited.mk.{1} Float (UInt64.toFloat (OfNat.ofNat.{0} UInt64 0 (UInt64.instOfNat 0)))
