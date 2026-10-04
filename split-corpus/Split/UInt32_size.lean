import Mathlib

set_option pp.all true
-- spec: UInt32.size : Nat
def UInt32.size : Nat :=
  OfNat.ofNat.{0} Nat 4294967296 (instOfNatNat 4294967296)
