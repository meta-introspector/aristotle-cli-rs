import Mathlib

set_option pp.all true
-- spec: instLEUInt32 : LE.{0} UInt32
def instLEUInt32 : LE.{0} UInt32 :=
  LE.mk.{0} UInt32 (fun (a : UInt32) (b : UInt32) => LE.le.{0} (BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (instLEBitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) (UInt32.toBitVec a) (UInt32.toBitVec b))
