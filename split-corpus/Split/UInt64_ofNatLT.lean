import Mathlib

set_option pp.all true
-- spec: UInt64.ofNatLT : forall (n : [mdata borrowed:1 Nat]), (LT.lt.{0} ([mdata borrowed:1 Nat]) instLTNat n UInt64.size) -> UInt64
def UInt64.ofNatLT : forall (n : [mdata borrowed:1 Nat]), (LT.lt.{0} ([mdata borrowed:1 Nat]) instLTNat n UInt64.size) -> UInt64 :=
  fun (n : Nat) (h : LT.lt.{0} ([mdata borrowed:1 Nat]) instLTNat n UInt64.size) => UInt64.ofBitVec (BitVec.ofNatLT (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64)) n h)
