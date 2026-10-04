import Mathlib

set_option pp.all true
-- spec: Something.EllipticCurve.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 32) -> (motive Something.EllipticCurve) -> (motive t)
def Something.EllipticCurve.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 32) -> (motive Something.EllipticCurve) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 32) (EllipticCurve : motive Something.EllipticCurve) => Something.ctorElim.{u} motive 32 t (Eq.symm.{1} Nat (Something.ctorIdx t) 32 h) (PULift.up.{u, u} (motive Something.EllipticCurve) EllipticCurve)
