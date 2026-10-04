import Mathlib

set_option pp.all true
-- spec: Nat.Linear.hugeFuel : Nat
def Nat.Linear.hugeFuel : Nat :=
  OfNat.ofNat.{0} Nat 1000000 (instOfNatNat 1000000)
