import Mathlib

set_option pp.all true
-- spec: Something.HottUU.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 34) -> (motive Something.HottUU) -> (motive t)
def Something.HottUU.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 34) -> (motive Something.HottUU) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 34) (HottUU : motive Something.HottUU) => Something.ctorElim.{u} motive 34 t (Eq.symm.{1} Nat (Something.ctorIdx t) 34 h) (PULift.up.{u, u} (motive Something.HottUU) HottUU)
