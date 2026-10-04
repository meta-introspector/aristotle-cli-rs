import Mathlib

set_option pp.all true
-- spec: instLTUInt32 : LT.{0} UInt32
def instLTUInt32 : LT.{0} UInt32 :=
  LT.mk.{0} UInt32 (fun (a : UInt32) (b : UInt32) => LT.lt.{0} (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (instLTBitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (UInt32.toBitVec a) (UInt32.toBitVec b))
