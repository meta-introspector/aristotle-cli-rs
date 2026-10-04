import Mathlib

set_option pp.all true
-- spec: UInt32.casesOn : forall {motive : UInt32 -> Sort.{u}} (t : UInt32), (forall (toBitVec : BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))), motive (UInt32.ofBitVec toBitVec)) -> (motive t)
def UInt32.casesOn : forall {motive : UInt32 -> Sort.{u}} (t : UInt32), (forall (toBitVec : BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))), motive (UInt32.ofBitVec toBitVec)) -> (motive t) :=
  fun {motive : UInt32 -> Sort.{u}} (t : UInt32) (ofBitVec : forall (toBitVec : BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))), motive (UInt32.ofBitVec toBitVec)) => UInt32.rec.{u} motive (fun (toBitVec : BitVec (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32))) => ofBitVec toBitVec) t
