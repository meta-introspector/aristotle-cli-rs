import Mathlib

set_option pp.all true
-- spec: Duality.Two.elim : forall {motive : Duality -> Sort.{u}} (t : Duality), (Eq.{1} Nat (Duality.ctorIdx t) 0) -> (motive Duality.Two) -> (motive t)
def Duality.Two.elim : forall {motive : Duality -> Sort.{u}} (t : Duality), (Eq.{1} Nat (Duality.ctorIdx t) 0) -> (motive Duality.Two) -> (motive t) :=
  fun {motive : Duality -> Sort.{u}} (t : Duality) (h : Eq.{1} Nat (Duality.ctorIdx t) 0) (Two : motive Duality.Two) => Duality.ctorElim.{u} motive 0 t (Eq.symm.{1} Nat (Duality.ctorIdx t) 0 h) (PULift.up.{u, u} (motive Duality.Two) Two)
