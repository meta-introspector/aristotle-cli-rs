import Mathlib

set_option pp.all true
-- spec: BitVec.casesOn : forall {w : Nat} {motive : (BitVec w) -> Sort.{u}} (t : BitVec w), (forall (toFin : Fin (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) w)), motive (BitVec.ofFin w toFin)) -> (motive t)
def BitVec.casesOn : forall {w : Nat} {motive : (BitVec w) -> Sort.{u}} (t : BitVec w), (forall (toFin : Fin (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) w)), motive (BitVec.ofFin w toFin)) -> (motive t) :=
  fun {w : Nat} {motive : (BitVec w) -> Sort.{u}} (t : BitVec w) (ofFin : forall (toFin : Fin (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) w)), motive (BitVec.ofFin w toFin)) => BitVec.rec.{u} w motive (fun (toFin : Fin (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) w)) => ofFin toFin) t
