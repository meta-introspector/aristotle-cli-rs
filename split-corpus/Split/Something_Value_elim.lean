import Mathlib

set_option pp.all true
-- spec: Something.Value.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 51) -> (motive Something.Value) -> (motive t)
def Something.Value.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 51) -> (motive Something.Value) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 51) (Value : motive Something.Value) => Something.ctorElim.{u} motive 51 t (Eq.symm.{1} Nat (Something.ctorIdx t) 51 h) (PULift.up.{u, u} (motive Something.Value) Value)
