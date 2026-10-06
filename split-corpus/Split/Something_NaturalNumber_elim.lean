import Mathlib

set_option pp.all true
-- spec: Something.NaturalNumber.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 52) -> (motive Something.NaturalNumber) -> (motive t)
def Something.NaturalNumber.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 52) -> (motive Something.NaturalNumber) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 52) (NaturalNumber : motive Something.NaturalNumber) => Something.ctorElim.{u} motive 52 t (Eq.symm.{1} Nat (Something.ctorIdx t) 52 h) (PULift.up.{u, u} (motive Something.NaturalNumber) NaturalNumber)
