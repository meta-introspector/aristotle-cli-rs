import Mathlib

set_option pp.all true
-- spec: UInt64.toNat : UInt64 -> Nat
def UInt64.toNat : UInt64 -> Nat :=
  fun (n : UInt64) => BitVec.toNat (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64)) (UInt64.toBitVec n)
