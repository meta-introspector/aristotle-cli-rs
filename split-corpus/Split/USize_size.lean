import Mathlib

set_option pp.all true
-- spec: USize.size : Nat
def USize.size : Nat :=
  HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) System.Platform.numBits
