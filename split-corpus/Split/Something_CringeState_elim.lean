import Mathlib

set_option pp.all true
-- spec: Something.CringeState.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 56) -> (motive Something.CringeState) -> (motive t)
def Something.CringeState.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 56) -> (motive Something.CringeState) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 56) (CringeState : motive Something.CringeState) => Something.ctorElim.{u} motive 56 t (Eq.symm.{1} Nat (Something.ctorIdx t) 56 h) (PULift.up.{u, u} (motive Something.CringeState) CringeState)
