import Mathlib

set_option pp.all true
-- spec: Lean.Name.str.elim : forall {motive : Lean.Name -> Sort.{u}} (t : Lean.Name), (Eq.{1} Nat (Lean.Name.ctorIdx t) 1) -> (forall (pre : Lean.Name) (str : String), motive (Lean.Name.str pre str)) -> (motive t)
def Lean.Name.str.elim : forall {motive : Lean.Name -> Sort.{u}} (t : Lean.Name), (Eq.{1} Nat (Lean.Name.ctorIdx t) 1) -> (forall (pre : Lean.Name) (str : String), motive (Lean.Name.str pre str)) -> (motive t) :=
  fun {motive : Lean.Name -> Sort.{u}} (t : Lean.Name) (h : Eq.{1} Nat (Lean.Name.ctorIdx t) 1) (str : forall (pre : Lean.Name) (str : String), motive (Lean.Name.str pre str)) => Lean.Name.ctorElim.{u} motive 1 t (Eq.symm.{1} Nat (Lean.Name.ctorIdx t) 1 h) (PULift.up.{u, u} (forall (pre : Lean.Name) (str : String), motive (Lean.Name.str pre str)) str)
