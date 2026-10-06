import Mathlib

set_option pp.all true
-- spec: Lean.Name.num.elim : forall {motive : Lean.Name -> Sort.{u}} (t : Lean.Name), (Eq.{1} Nat (Lean.Name.ctorIdx t) 2) -> (forall (pre : Lean.Name) (i : Nat), motive (Lean.Name.num pre i)) -> (motive t)
def Lean.Name.num.elim : forall {motive : Lean.Name -> Sort.{u}} (t : Lean.Name), (Eq.{1} Nat (Lean.Name.ctorIdx t) 2) -> (forall (pre : Lean.Name) (i : Nat), motive (Lean.Name.num pre i)) -> (motive t) :=
  fun {motive : Lean.Name -> Sort.{u}} (t : Lean.Name) (h : Eq.{1} Nat (Lean.Name.ctorIdx t) 2) (num : forall (pre : Lean.Name) (i : Nat), motive (Lean.Name.num pre i)) => Lean.Name.ctorElim.{u} motive 2 t (Eq.symm.{1} Nat (Lean.Name.ctorIdx t) 2 h) (PULift.up.{u, u} (forall (pre : Lean.Name) (i : Nat), motive (Lean.Name.num pre i)) num)
