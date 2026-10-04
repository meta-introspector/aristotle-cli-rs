import Mathlib

set_option pp.all true
-- spec: Duality.Boolean.elim : forall {motive : Duality -> Sort.{u}} (t : Duality), (Eq.{1} Nat (Duality.ctorIdx t) 5) -> (motive Duality.Boolean) -> (motive t)
def Duality.Boolean.elim : forall {motive : Duality -> Sort.{u}} (t : Duality), (Eq.{1} Nat (Duality.ctorIdx t) 5) -> (motive Duality.Boolean) -> (motive t) :=
  fun {motive : Duality -> Sort.{u}} (t : Duality) (h : Eq.{1} Nat (Duality.ctorIdx t) 5) (Boolean : motive Duality.Boolean) => Duality.ctorElim.{u} motive 5 t (Eq.symm.{1} Nat (Duality.ctorIdx t) 5 h) (PULift.up.{u, u} (motive Duality.Boolean) Boolean)
