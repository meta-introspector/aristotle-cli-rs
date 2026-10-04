import Mathlib

set_option pp.all true
-- spec: UInt32.mod : UInt32 -> UInt32 -> UInt32
def UInt32.mod : UInt32 -> UInt32 -> UInt32 :=
  fun (a : UInt32) (b : UInt32) => UInt32.ofBitVec (BitVec.umod (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32)) (UInt32.toBitVec a) (UInt32.toBitVec b))
