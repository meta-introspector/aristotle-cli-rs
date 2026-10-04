import Mathlib

set_option pp.all true
-- spec: Something.ThisLeanFile.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 1) -> (motive Something.ThisLeanFile) -> (motive t)
def Something.ThisLeanFile.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 1) -> (motive Something.ThisLeanFile) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 1) (ThisLeanFile : motive Something.ThisLeanFile) => Something.ctorElim.{u} motive 1 t (Eq.symm.{1} Nat (Something.ctorIdx t) 1 h) (PULift.up.{u, u} (motive Something.ThisLeanFile) ThisLeanFile)
