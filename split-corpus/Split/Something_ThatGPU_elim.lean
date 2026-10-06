import Mathlib

set_option pp.all true
-- spec: Something.ThatGPU.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 46) -> (motive Something.ThatGPU) -> (motive t)
def Something.ThatGPU.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 46) -> (motive Something.ThatGPU) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 46) (ThatGPU : motive Something.ThatGPU) => Something.ctorElim.{u} motive 46 t (Eq.symm.{1} Nat (Something.ctorIdx t) 46 h) (PULift.up.{u, u} (motive Something.ThatGPU) ThatGPU)
