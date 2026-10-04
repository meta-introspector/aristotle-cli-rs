import Mathlib

set_option pp.all true
-- spec: UInt32.toUInt64 : UInt32 -> UInt64
def UInt32.toUInt64 : UInt32 -> UInt64 :=
  fun (a : UInt32) => UInt64.ofBitVec (BitVec.ofFin (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64)) (Fin.mk (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))) (UInt32.toNat a) (UInt32.toUInt64._proof_2 a)))
