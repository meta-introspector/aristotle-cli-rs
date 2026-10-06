import Mathlib

set_option pp.all true
-- spec: Something.StringTheory.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 54) -> (motive Something.StringTheory) -> (motive t)
def Something.StringTheory.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 54) -> (motive Something.StringTheory) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 54) (StringTheory : motive Something.StringTheory) => Something.ctorElim.{u} motive 54 t (Eq.symm.{1} Nat (Something.ctorIdx t) 54 h) (PULift.up.{u, u} (motive Something.StringTheory) StringTheory)
