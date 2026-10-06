import Mathlib

set_option pp.all true
-- spec: Nat.Linear.fixedVar : Nat
def Nat.Linear.fixedVar : Nat :=
  OfNat.ofNat.{0} Nat 100000000 (instOfNatNat 100000000)
