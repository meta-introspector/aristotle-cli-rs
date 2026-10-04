import Mathlib

set_option pp.all true
-- spec: UInt32.ofNatLT : forall (n : [mdata borrowed:1 Nat]), (LT.lt.{0} ([mdata borrowed:1 Nat]) instLTNat n UInt32.size) -> UInt32
def UInt32.ofNatLT : forall (n : [mdata borrowed:1 Nat]), (LT.lt.{0} ([mdata borrowed:1 Nat]) instLTNat n UInt32.size) -> UInt32 :=
  fun (n : Nat) (h : LT.lt.{0} ([mdata borrowed:1 Nat]) instLTNat n UInt32.size) => UInt32.ofBitVec (BitVec.ofNatLT (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32)) n h)
