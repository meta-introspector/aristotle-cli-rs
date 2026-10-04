import Mathlib

set_option pp.all true
-- spec: UInt8.add : UInt8 -> UInt8 -> UInt8
def UInt8.add : UInt8 -> UInt8 -> UInt8 :=
  fun (a : UInt8) (b : UInt8) => UInt8.ofBitVec (HAdd.hAdd.{0, 0, 0} (BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (instHAdd.{0} (BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) (BitVec.instAdd (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8)))) (UInt8.toBitVec a) (UInt8.toBitVec b))
