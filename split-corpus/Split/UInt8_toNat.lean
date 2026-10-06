import Mathlib

set_option pp.all true
-- spec: UInt8.toNat : UInt8 -> Nat
def UInt8.toNat : UInt8 -> Nat :=
  fun (n : UInt8) => BitVec.toNat (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)) (UInt8.toBitVec n)
