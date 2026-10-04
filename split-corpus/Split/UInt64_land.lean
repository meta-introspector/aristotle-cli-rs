import Mathlib

set_option pp.all true
-- spec: UInt64.land : UInt64 -> UInt64 -> UInt64
def UInt64.land : UInt64 -> UInt64 -> UInt64 :=
  fun (a : UInt64) (b : UInt64) => UInt64.ofBitVec (HAnd.hAnd.{0, 0, 0} (BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))) (BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))) (BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))) (instHAndOfAndOp.{0} (BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))) (BitVec.instAndOp (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64)))) (UInt64.toBitVec a) (UInt64.toBitVec b))
