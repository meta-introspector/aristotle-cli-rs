import Mathlib

set_option pp.all true
-- spec: Something.PrimeFactorization.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 53) -> (motive Something.PrimeFactorization) -> (motive t)
def Something.PrimeFactorization.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 53) -> (motive Something.PrimeFactorization) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 53) (PrimeFactorization : motive Something.PrimeFactorization) => Something.ctorElim.{u} motive 53 t (Eq.symm.{1} Nat (Something.ctorIdx t) 53 h) (PULift.up.{u, u} (motive Something.PrimeFactorization) PrimeFactorization)
