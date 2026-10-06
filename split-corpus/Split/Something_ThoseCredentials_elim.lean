import Mathlib

set_option pp.all true
-- spec: Something.ThoseCredentials.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 13) -> (motive Something.ThoseCredentials) -> (motive t)
def Something.ThoseCredentials.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 13) -> (motive Something.ThoseCredentials) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 13) (ThoseCredentials : motive Something.ThoseCredentials) => Something.ctorElim.{u} motive 13 t (Eq.symm.{1} Nat (Something.ctorIdx t) 13 h) (PULift.up.{u, u} (motive Something.ThoseCredentials) ThoseCredentials)
