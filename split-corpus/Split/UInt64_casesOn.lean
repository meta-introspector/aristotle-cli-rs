import Mathlib

set_option pp.all true
-- spec: UInt64.casesOn : forall {motive : UInt64 -> Sort.{u}} (t : UInt64), (forall (toBitVec : BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))), motive (UInt64.ofBitVec toBitVec)) -> (motive t)
def UInt64.casesOn : forall {motive : UInt64 -> Sort.{u}} (t : UInt64), (forall (toBitVec : BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))), motive (UInt64.ofBitVec toBitVec)) -> (motive t) :=
  fun {motive : UInt64 -> Sort.{u}} (t : UInt64) (ofBitVec : forall (toBitVec : BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))), motive (UInt64.ofBitVec toBitVec)) => UInt64.rec.{u} motive (fun (toBitVec : BitVec (OfNat.ofNat.{0} Nat 64 (instOfNatNat 64))) => ofBitVec toBitVec) t
