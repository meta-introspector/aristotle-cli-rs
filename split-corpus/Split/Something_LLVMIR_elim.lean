import Mathlib

set_option pp.all true
-- spec: Something.LLVMIR.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 40) -> (motive Something.LLVMIR) -> (motive t)
def Something.LLVMIR.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 40) -> (motive Something.LLVMIR) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 40) (LLVMIR : motive Something.LLVMIR) => Something.ctorElim.{u} motive 40 t (Eq.symm.{1} Nat (Something.ctorIdx t) 40 h) (PULift.up.{u, u} (motive Something.LLVMIR) LLVMIR)
