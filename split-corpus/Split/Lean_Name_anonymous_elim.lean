import Mathlib

set_option pp.all true
-- spec: Lean.Name.anonymous.elim : forall {motive : Lean.Name -> Sort.{u}} (t : Lean.Name), (Eq.{1} Nat (Lean.Name.ctorIdx t) 0) -> (motive Lean.Name.anonymous) -> (motive t)
def Lean.Name.anonymous.elim : forall {motive : Lean.Name -> Sort.{u}} (t : Lean.Name), (Eq.{1} Nat (Lean.Name.ctorIdx t) 0) -> (motive Lean.Name.anonymous) -> (motive t) :=
  fun {motive : Lean.Name -> Sort.{u}} (t : Lean.Name) (h : Eq.{1} Nat (Lean.Name.ctorIdx t) 0) (anonymous : motive Lean.Name.anonymous) => Lean.Name.ctorElim.{u} motive 0 t (Eq.symm.{1} Nat (Lean.Name.ctorIdx t) 0 h) (PULift.up.{u, u} (motive Lean.Name.anonymous) anonymous)
