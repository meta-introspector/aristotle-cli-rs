import Mathlib

set_option pp.all true
-- spec: Something.SomeWasmFile.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 6) -> (motive Something.SomeWasmFile) -> (motive t)
def Something.SomeWasmFile.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 6) -> (motive Something.SomeWasmFile) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 6) (SomeWasmFile : motive Something.SomeWasmFile) => Something.ctorElim.{u} motive 6 t (Eq.symm.{1} Nat (Something.ctorIdx t) 6 h) (PULift.up.{u, u} (motive Something.SomeWasmFile) SomeWasmFile)
