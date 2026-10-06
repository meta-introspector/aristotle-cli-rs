import Mathlib

set_option pp.all true
-- spec: Something.ThisLeanMeta.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 2) -> (motive Something.ThisLeanMeta) -> (motive t)
def Something.ThisLeanMeta.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 2) -> (motive Something.ThisLeanMeta) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 2) (ThisLeanMeta : motive Something.ThisLeanMeta) => Something.ctorElim.{u} motive 2 t (Eq.symm.{1} Nat (Something.ctorIdx t) 2 h) (PULift.up.{u, u} (motive Something.ThisLeanMeta) ThisLeanMeta)
