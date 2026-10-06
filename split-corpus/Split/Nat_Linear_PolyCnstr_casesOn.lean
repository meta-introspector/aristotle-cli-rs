import Mathlib

set_option pp.all true
-- spec: Nat.Linear.PolyCnstr.casesOn : forall {motive : Nat.Linear.PolyCnstr -> Sort.{u}} (t : Nat.Linear.PolyCnstr), (forall (eq : Bool) (lhs : Nat.Linear.Poly) (rhs : Nat.Linear.Poly), motive (Nat.Linear.PolyCnstr.mk eq lhs rhs)) -> (motive t)
def Nat.Linear.PolyCnstr.casesOn : forall {motive : Nat.Linear.PolyCnstr -> Sort.{u}} (t : Nat.Linear.PolyCnstr), (forall (eq : Bool) (lhs : Nat.Linear.Poly) (rhs : Nat.Linear.Poly), motive (Nat.Linear.PolyCnstr.mk eq lhs rhs)) -> (motive t) :=
  fun {motive : Nat.Linear.PolyCnstr -> Sort.{u}} (t : Nat.Linear.PolyCnstr) (mk : forall (eq : Bool) (lhs : Nat.Linear.Poly) (rhs : Nat.Linear.Poly), motive (Nat.Linear.PolyCnstr.mk eq lhs rhs)) => Nat.Linear.PolyCnstr.rec.{u} motive (fun (eq : Bool) (lhs : Nat.Linear.Poly) (rhs : Nat.Linear.Poly) => mk eq lhs rhs) t
