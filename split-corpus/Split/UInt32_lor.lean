import Mathlib

set_option pp.all true
-- spec: UInt32.lor : UInt32 -> UInt32 -> UInt32
def UInt32.lor : UInt32 -> UInt32 -> UInt32 :=
  fun (a : UInt32) (b : UInt32) => UInt32.ofBitVec (HOr.hOr.{0, 0, 0} (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (instHOrOfOrOp.{0} (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (BitVec.instOrOp (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32)))) (UInt32.toBitVec a) (UInt32.toBitVec b))
