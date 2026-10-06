import Mathlib

set_option pp.all true
-- spec: Something.SomeRustFile.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 5) -> (motive Something.SomeRustFile) -> (motive t)
def Something.SomeRustFile.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 5) -> (motive Something.SomeRustFile) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 5) (SomeRustFile : motive Something.SomeRustFile) => Something.ctorElim.{u} motive 5 t (Eq.symm.{1} Nat (Something.ctorIdx t) 5 h) (PULift.up.{u, u} (motive Something.SomeRustFile) SomeRustFile)
