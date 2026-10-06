import Mathlib

set_option pp.all true
-- spec: Something.ThatFreeTierLLModel.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 14) -> (motive Something.ThatFreeTierLLModel) -> (motive t)
def Something.ThatFreeTierLLModel.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 14) -> (motive Something.ThatFreeTierLLModel) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 14) (ThatFreeTierLLModel : motive Something.ThatFreeTierLLModel) => Something.ctorElim.{u} motive 14 t (Eq.symm.{1} Nat (Something.ctorIdx t) 14 h) (PULift.up.{u, u} (motive Something.ThatFreeTierLLModel) ThatFreeTierLLModel)
