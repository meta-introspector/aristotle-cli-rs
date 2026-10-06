import Mathlib

set_option pp.all true
-- spec: UInt32.toNat : UInt32 -> Nat
def UInt32.toNat : UInt32 -> Nat :=
  fun (n : UInt32) => BitVec.toNat (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32)) (UInt32.toBitVec n)
