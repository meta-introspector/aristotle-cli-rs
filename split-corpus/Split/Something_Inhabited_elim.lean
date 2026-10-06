import Mathlib

set_option pp.all true
-- spec: Something.Inhabited.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 63) -> (motive Something.Inhabited) -> (motive t)
def Something.Inhabited.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 63) -> (motive Something.Inhabited) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 63) (Inhabited : motive Something.Inhabited) => Something.ctorElim.{u} motive 63 t (Eq.symm.{1} Nat (Something.ctorIdx t) 63 h) (PULift.up.{u, u} (motive Something.Inhabited) Inhabited)
