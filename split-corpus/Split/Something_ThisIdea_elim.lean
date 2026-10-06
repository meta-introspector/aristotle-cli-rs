import Mathlib

set_option pp.all true
-- spec: Something.ThisIdea.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 0) -> (motive Something.ThisIdea) -> (motive t)
def Something.ThisIdea.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 0) -> (motive Something.ThisIdea) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 0) (ThisIdea : motive Something.ThisIdea) => Something.ctorElim.{u} motive 0 t (Eq.symm.{1} Nat (Something.ctorIdx t) 0 h) (PULift.up.{u, u} (motive Something.ThisIdea) ThisIdea)
