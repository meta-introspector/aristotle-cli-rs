import Mathlib

set_option pp.all true
-- spec: UInt64.size : Nat
def UInt64.size : Nat :=
  OfNat.ofNat.{0} Nat 18446744073709551616 (instOfNatNat 18446744073709551616)
