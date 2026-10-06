import Mathlib

set_option pp.all true
-- spec: Something.Rewrite.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 62) -> (motive Something.Rewrite) -> (motive t)
def Something.Rewrite.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 62) -> (motive Something.Rewrite) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 62) (Rewrite : motive Something.Rewrite) => Something.ctorElim.{u} motive 62 t (Eq.symm.{1} Nat (Something.ctorIdx t) 62 h) (PULift.up.{u, u} (motive Something.Rewrite) Rewrite)
