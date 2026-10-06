import Mathlib

set_option pp.all true
-- spec: Eigenspace.earth.elim : forall {motive : Eigenspace -> Sort.{u}} (t : Eigenspace), (Eq.{1} Nat (Eigenspace.ctorIdx t) 0) -> (motive Eigenspace.earth) -> (motive t)
def Eigenspace.earth.elim : forall {motive : Eigenspace -> Sort.{u}} (t : Eigenspace), (Eq.{1} Nat (Eigenspace.ctorIdx t) 0) -> (motive Eigenspace.earth) -> (motive t) :=
  fun {motive : Eigenspace -> Sort.{u}} (t : Eigenspace) (h : Eq.{1} Nat (Eigenspace.ctorIdx t) 0) (earth : motive Eigenspace.earth) => Eigenspace.ctorElim.{u} motive 0 t (Eq.symm.{1} Nat (Eigenspace.ctorIdx t) 0 h) (PULift.up.{u, u} (motive Eigenspace.earth) earth)
