import Mathlib

set_option pp.all true
-- spec: Duality.Binary.elim : forall {motive : Duality -> Sort.{u}} (t : Duality), (Eq.{1} Nat (Duality.ctorIdx t) 2) -> (motive Duality.Binary) -> (motive t)
def Duality.Binary.elim : forall {motive : Duality -> Sort.{u}} (t : Duality), (Eq.{1} Nat (Duality.ctorIdx t) 2) -> (motive Duality.Binary) -> (motive t) :=
  fun {motive : Duality -> Sort.{u}} (t : Duality) (h : Eq.{1} Nat (Duality.ctorIdx t) 2) (Binary : motive Duality.Binary) => Duality.ctorElim.{u} motive 2 t (Eq.symm.{1} Nat (Duality.ctorIdx t) 2 h) (PULift.up.{u, u} (motive Duality.Binary) Binary)
