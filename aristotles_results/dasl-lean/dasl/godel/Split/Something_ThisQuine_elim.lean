import Mathlib

set_option pp.all true
-- spec: Something.ThisQuine.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 36) -> (motive Something.ThisQuine) -> (motive t)
def Something.ThisQuine.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 36) -> (motive Something.ThisQuine) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 36) (ThisQuine : motive Something.ThisQuine) => Something.ctorElim.{u} motive 36 t (Eq.symm.{1} Nat (Something.ctorIdx t) 36 h) (PULift.up.{u, u} (motive Something.ThisQuine) ThisQuine)
