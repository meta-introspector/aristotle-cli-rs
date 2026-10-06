import Mathlib

set_option pp.all true
-- spec: instInhabitedNat : Inhabited.{1} Nat
def instInhabitedNat : Inhabited.{1} Nat :=
  Inhabited.mk.{1} Nat Nat.zero
