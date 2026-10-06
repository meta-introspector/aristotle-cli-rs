import Mathlib

set_option pp.all true
-- spec: Duality.Bit.elim : forall {motive : Duality -> Sort.{u}} (t : Duality), (Eq.{1} Nat (Duality.ctorIdx t) 1) -> (motive Duality.Bit) -> (motive t)
def Duality.Bit.elim : forall {motive : Duality -> Sort.{u}} (t : Duality), (Eq.{1} Nat (Duality.ctorIdx t) 1) -> (motive Duality.Bit) -> (motive t) :=
  fun {motive : Duality -> Sort.{u}} (t : Duality) (h : Eq.{1} Nat (Duality.ctorIdx t) 1) (Bit : motive Duality.Bit) => Duality.ctorElim.{u} motive 1 t (Eq.symm.{1} Nat (Duality.ctorIdx t) 1 h) (PULift.up.{u, u} (motive Duality.Bit) Bit)
