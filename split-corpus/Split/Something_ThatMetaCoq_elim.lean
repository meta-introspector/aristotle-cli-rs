import Mathlib

set_option pp.all true
-- spec: Something.ThatMetaCoq.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 3) -> (motive Something.ThatMetaCoq) -> (motive t)
def Something.ThatMetaCoq.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 3) -> (motive Something.ThatMetaCoq) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 3) (ThatMetaCoq : motive Something.ThatMetaCoq) => Something.ctorElim.{u} motive 3 t (Eq.symm.{1} Nat (Something.ctorIdx t) 3 h) (PULift.up.{u, u} (motive Something.ThatMetaCoq) ThatMetaCoq)
