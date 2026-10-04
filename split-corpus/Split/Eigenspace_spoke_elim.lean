import Mathlib

set_option pp.all true
-- spec: Eigenspace.spoke.elim : forall {motive : Eigenspace -> Sort.{u}} (t : Eigenspace), (Eq.{1} Nat (Eigenspace.ctorIdx t) 1) -> (motive Eigenspace.spoke) -> (motive t)
def Eigenspace.spoke.elim : forall {motive : Eigenspace -> Sort.{u}} (t : Eigenspace), (Eq.{1} Nat (Eigenspace.ctorIdx t) 1) -> (motive Eigenspace.spoke) -> (motive t) :=
  fun {motive : Eigenspace -> Sort.{u}} (t : Eigenspace) (h : Eq.{1} Nat (Eigenspace.ctorIdx t) 1) (spoke : motive Eigenspace.spoke) => Eigenspace.ctorElim.{u} motive 1 t (Eq.symm.{1} Nat (Eigenspace.ctorIdx t) 1 h) (PULift.up.{u, u} (motive Eigenspace.spoke) spoke)
