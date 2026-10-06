import Mathlib

set_option pp.all true
-- spec: UInt8.casesOn : forall {motive : UInt8 -> Sort.{u}} (t : UInt8), (forall (toBitVec : BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))), motive (UInt8.ofBitVec toBitVec)) -> (motive t)
def UInt8.casesOn : forall {motive : UInt8 -> Sort.{u}} (t : UInt8), (forall (toBitVec : BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))), motive (UInt8.ofBitVec toBitVec)) -> (motive t) :=
  fun {motive : UInt8 -> Sort.{u}} (t : UInt8) (ofBitVec : forall (toBitVec : BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))), motive (UInt8.ofBitVec toBitVec)) => UInt8.rec.{u} motive (fun (toBitVec : BitVec (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))) => ofBitVec toBitVec) t
