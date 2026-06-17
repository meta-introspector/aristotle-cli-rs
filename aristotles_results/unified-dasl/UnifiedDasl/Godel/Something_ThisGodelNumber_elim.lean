import Mathlib

set_option pp.all true
-- spec: Something.ThisGodelNumber.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 35) -> (motive Something.ThisGodelNumber) -> (motive t)
def Something.ThisGodelNumber.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 35) -> (motive Something.ThisGodelNumber) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 35) (ThisGodelNumber : motive Something.ThisGodelNumber) => Something.ctorElim.{u} motive 35 t (Eq.symm.{1} Nat (Something.ctorIdx t) 35 h) (PULift.up.{u, u} (motive Something.ThisGodelNumber) ThisGodelNumber)
