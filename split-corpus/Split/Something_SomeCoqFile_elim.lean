import Mathlib

set_option pp.all true
-- spec: Something.SomeCoqFile.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 4) -> (motive Something.SomeCoqFile) -> (motive t)
def Something.SomeCoqFile.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 4) -> (motive Something.SomeCoqFile) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 4) (SomeCoqFile : motive Something.SomeCoqFile) => Something.ctorElim.{u} motive 4 t (Eq.symm.{1} Nat (Something.ctorIdx t) 4 h) (PULift.up.{u, u} (motive Something.SomeCoqFile) SomeCoqFile)
