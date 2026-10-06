import Mathlib

set_option pp.all true
-- spec: UInt32.add : UInt32 -> UInt32 -> UInt32
def UInt32.add : UInt32 -> UInt32 -> UInt32 :=
  fun (a : UInt32) (b : UInt32) => UInt32.ofBitVec (HAdd.hAdd.{0, 0, 0} (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (instHAdd.{0} (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (BitVec.instAdd (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32)))) (UInt32.toBitVec a) (UInt32.toBitVec b))
