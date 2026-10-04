import Mathlib

set_option pp.all true
-- spec: Something.Cache.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 49) -> (motive Something.Cache) -> (motive t)
def Something.Cache.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 49) -> (motive Something.Cache) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 49) (Cache : motive Something.Cache) => Something.ctorElim.{u} motive 49 t (Eq.symm.{1} Nat (Something.ctorIdx t) 49 h) (PULift.up.{u, u} (motive Something.Cache) Cache)
