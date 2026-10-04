import Mathlib

set_option pp.all true
-- spec: Something.LLModelLayer.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 15) -> (motive Something.LLModelLayer) -> (motive t)
def Something.LLModelLayer.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 15) -> (motive Something.LLModelLayer) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 15) (LLModelLayer : motive Something.LLModelLayer) => Something.ctorElim.{u} motive 15 t (Eq.symm.{1} Nat (Something.ctorIdx t) 15 h) (PULift.up.{u, u} (motive Something.LLModelLayer) LLModelLayer)
