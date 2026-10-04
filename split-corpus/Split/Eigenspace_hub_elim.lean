import Mathlib

set_option pp.all true
-- spec: Eigenspace.hub.elim : forall {motive : Eigenspace -> Sort.{u}} (t : Eigenspace), (Eq.{1} Nat (Eigenspace.ctorIdx t) 2) -> (motive Eigenspace.hub) -> (motive t)
def Eigenspace.hub.elim : forall {motive : Eigenspace -> Sort.{u}} (t : Eigenspace), (Eq.{1} Nat (Eigenspace.ctorIdx t) 2) -> (motive Eigenspace.hub) -> (motive t) :=
  fun {motive : Eigenspace -> Sort.{u}} (t : Eigenspace) (h : Eq.{1} Nat (Eigenspace.ctorIdx t) 2) (hub : motive Eigenspace.hub) => Eigenspace.ctorElim.{u} motive 2 t (Eq.symm.{1} Nat (Eigenspace.ctorIdx t) 2 h) (PULift.up.{u, u} (motive Eigenspace.hub) hub)
