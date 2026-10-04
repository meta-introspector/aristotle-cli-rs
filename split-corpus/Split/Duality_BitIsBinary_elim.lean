import Mathlib

set_option pp.all true
-- spec: Duality.BitIsBinary.elim : forall {motive : Duality -> Sort.{u}} (t : Duality), (Eq.{1} Nat (Duality.ctorIdx t) 4) -> (motive Duality.BitIsBinary) -> (motive t)
def Duality.BitIsBinary.elim : forall {motive : Duality -> Sort.{u}} (t : Duality), (Eq.{1} Nat (Duality.ctorIdx t) 4) -> (motive Duality.BitIsBinary) -> (motive t) :=
  fun {motive : Duality -> Sort.{u}} (t : Duality) (h : Eq.{1} Nat (Duality.ctorIdx t) 4) (BitIsBinary : motive Duality.BitIsBinary) => Duality.ctorElim.{u} motive 4 t (Eq.symm.{1} Nat (Duality.ctorIdx t) 4 h) (PULift.up.{u, u} (motive Duality.BitIsBinary) BitIsBinary)
