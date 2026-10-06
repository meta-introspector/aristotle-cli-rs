import Mathlib

set_option pp.all true
-- spec: Something.Hott.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 33) -> (motive Something.Hott) -> (motive t)
def Something.Hott.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 33) -> (motive Something.Hott) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 33) (Hott : motive Something.Hott) => Something.ctorElim.{u} motive 33 t (Eq.symm.{1} Nat (Something.ctorIdx t) 33 h) (PULift.up.{u, u} (motive Something.Hott) Hott)
