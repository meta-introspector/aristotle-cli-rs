import Mathlib

set_option pp.all true
-- spec: UInt32.shiftLeft : UInt32 -> UInt32 -> UInt32
def UInt32.shiftLeft : UInt32 -> UInt32 -> UInt32 :=
  fun (a : UInt32) (b : UInt32) => UInt32.ofBitVec (HShiftLeft.hShiftLeft.{0, 0, 0} (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (BitVec.instHShiftLeft (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32)) (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (UInt32.toBitVec a) (UInt32.toBitVec (UInt32.mod b (OfNat.ofNat.{0} UInt32 32 (UInt32.instOfNat 32)))))
