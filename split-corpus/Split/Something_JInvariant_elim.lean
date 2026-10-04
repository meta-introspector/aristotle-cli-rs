import Mathlib

set_option pp.all true
-- spec: Something.JInvariant.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 30) -> (motive Something.JInvariant) -> (motive t)
def Something.JInvariant.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 30) -> (motive Something.JInvariant) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 30) (JInvariant : motive Something.JInvariant) => Something.ctorElim.{u} motive 30 t (Eq.symm.{1} Nat (Something.ctorIdx t) 30 h) (PULift.up.{u, u} (motive Something.JInvariant) JInvariant)
