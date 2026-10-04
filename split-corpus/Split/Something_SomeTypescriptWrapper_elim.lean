import Mathlib

set_option pp.all true
-- spec: Something.SomeTypescriptWrapper.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 7) -> (motive Something.SomeTypescriptWrapper) -> (motive t)
def Something.SomeTypescriptWrapper.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 7) -> (motive Something.SomeTypescriptWrapper) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 7) (SomeTypescriptWrapper : motive Something.SomeTypescriptWrapper) => Something.ctorElim.{u} motive 7 t (Eq.symm.{1} Nat (Something.ctorIdx t) 7 h) (PULift.up.{u, u} (motive Something.SomeTypescriptWrapper) SomeTypescriptWrapper)
