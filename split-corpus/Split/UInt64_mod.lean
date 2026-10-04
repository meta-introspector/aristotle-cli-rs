import Mathlib

set_option pp.all true
-- spec: UInt64.mod : UInt64 -> UInt64 -> UInt64
def UInt64.mod : UInt64 -> UInt64 -> UInt64 :=
  fun (a : UInt64) (b : UInt64) => UInt64.ofBitVec (BitVec.umod (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64)) (UInt64.toBitVec a) (UInt64.toBitVec b))
