import Mathlib

set_option pp.all true
-- spec: Duality.Symmetry.elim : forall {motive : Duality -> Sort.{u}} (t : Duality), (Eq.{1} Nat (Duality.ctorIdx t) 3) -> (motive Duality.Symmetry) -> (motive t)
def Duality.Symmetry.elim : forall {motive : Duality -> Sort.{u}} (t : Duality), (Eq.{1} Nat (Duality.ctorIdx t) 3) -> (motive Duality.Symmetry) -> (motive t) :=
  fun {motive : Duality -> Sort.{u}} (t : Duality) (h : Eq.{1} Nat (Duality.ctorIdx t) 3) (Symmetry : motive Duality.Symmetry) => Duality.ctorElim.{u} motive 3 t (Eq.symm.{1} Nat (Duality.ctorIdx t) 3 h) (PULift.up.{u, u} (motive Duality.Symmetry) Symmetry)
