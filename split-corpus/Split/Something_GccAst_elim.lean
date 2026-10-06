import Mathlib

set_option pp.all true
-- spec: Something.GccAst.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 39) -> (motive Something.GccAst) -> (motive t)
def Something.GccAst.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 39) -> (motive Something.GccAst) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 39) (GccAst : motive Something.GccAst) => Something.ctorElim.{u} motive 39 t (Eq.symm.{1} Nat (Something.ctorIdx t) 39 h) (PULift.up.{u, u} (motive Something.GccAst) GccAst)
