import Mathlib

set_option pp.all true
-- spec: Something.ThisQuineGodelNumber.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 37) -> (motive Something.ThisQuineGodelNumber) -> (motive t)
def Something.ThisQuineGodelNumber.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 37) -> (motive Something.ThisQuineGodelNumber) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 37) (ThisQuineGodelNumber : motive Something.ThisQuineGodelNumber) => Something.ctorElim.{u} motive 37 t (Eq.symm.{1} Nat (Something.ctorIdx t) 37 h) (PULift.up.{u, u} (motive Something.ThisQuineGodelNumber) ThisQuineGodelNumber)
