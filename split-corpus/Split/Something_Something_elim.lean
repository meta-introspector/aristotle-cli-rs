import Mathlib

set_option pp.all true
-- spec: Something.Something.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 60) -> (motive Something.Something) -> (motive t)
def Something.Something.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 60) -> (motive Something.Something) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 60) (Something_1 : motive Something.Something) => Something.ctorElim.{u} motive 60 t (Eq.symm.{1} Nat (Something.ctorIdx t) 60 h) (PULift.up.{u, u} (motive Something.Something) Something_1)
