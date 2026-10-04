import Mathlib

set_option pp.all true
-- spec: UInt64.xor : UInt64 -> UInt64 -> UInt64
def UInt64.xor : UInt64 -> UInt64 -> UInt64 :=
  fun (a : UInt64) (b : UInt64) => UInt64.ofBitVec (HXor.hXor.{0, 0, 0} (BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))) (BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))) (BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))) (instHXorOfXorOp.{0} (BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))) (BitVec.instXorOp (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64)))) (UInt64.toBitVec a) (UInt64.toBitVec b))
