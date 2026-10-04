import Mathlib

set_option pp.all true
-- spec: Something.ThatLLModel.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 12) -> (motive Something.ThatLLModel) -> (motive t)
def Something.ThatLLModel.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 12) -> (motive Something.ThatLLModel) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 12) (ThatLLModel : motive Something.ThatLLModel) => Something.ctorElim.{u} motive 12 t (Eq.symm.{1} Nat (Something.ctorIdx t) 12 h) (PULift.up.{u, u} (motive Something.ThatLLModel) ThatLLModel)
