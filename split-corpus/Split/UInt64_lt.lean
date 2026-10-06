import Mathlib

set_option pp.all true
-- spec: UInt64.lt : UInt64 -> UInt64 -> Prop
def UInt64.lt : UInt64 -> UInt64 -> Prop :=
  fun (a : UInt64) (b : UInt64) => LT.lt.{0} (BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))) (instLTBitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))) (UInt64.toBitVec a) (UInt64.toBitVec b)
