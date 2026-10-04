import Mathlib

set_option pp.all true
-- spec: Something.ComplexNumber.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 31) -> (motive Something.ComplexNumber) -> (motive t)
def Something.ComplexNumber.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 31) -> (motive Something.ComplexNumber) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 31) (ComplexNumber : motive Something.ComplexNumber) => Something.ctorElim.{u} motive 31 t (Eq.symm.{1} Nat (Something.ctorIdx t) 31 h) (PULift.up.{u, u} (motive Something.ComplexNumber) ComplexNumber)
