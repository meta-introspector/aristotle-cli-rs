import Mathlib

set_option pp.all true
-- spec: UInt8.toUInt32 : UInt8 -> UInt32
def UInt8.toUInt32 : UInt8 -> UInt32 :=
  fun (a : UInt8) => UInt32.ofBitVec (BitVec.ofFin (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32)) (Fin.mk (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (UInt8.toNat a) (UInt8.toUInt32._proof_2 a)))
