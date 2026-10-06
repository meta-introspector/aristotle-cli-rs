import Mathlib

set_option pp.all true
-- spec: Something.SomeTypescriptClient.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 8) -> (motive Something.SomeTypescriptClient) -> (motive t)
def Something.SomeTypescriptClient.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 8) -> (motive Something.SomeTypescriptClient) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 8) (SomeTypescriptClient : motive Something.SomeTypescriptClient) => Something.ctorElim.{u} motive 8 t (Eq.symm.{1} Nat (Something.ctorIdx t) 8 h) (PULift.up.{u, u} (motive Something.SomeTypescriptClient) SomeTypescriptClient)
