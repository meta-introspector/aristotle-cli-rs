import Mathlib

set_option pp.all true
-- spec: UInt64.shiftRight : UInt64 -> UInt64 -> UInt64
def UInt64.shiftRight : UInt64 -> UInt64 -> UInt64 :=
  fun (a : UInt64) (b : UInt64) => UInt64.ofBitVec (HShiftRight.hShiftRight.{0, 0, 0} (BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))) (BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))) (BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))) (BitVec.instHShiftRight (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64)) (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))) (UInt64.toBitVec a) (UInt64.toBitVec (UInt64.mod b (OfNat.ofNat.{0} UInt64 64 (UInt64.instOfNat 64)))))
