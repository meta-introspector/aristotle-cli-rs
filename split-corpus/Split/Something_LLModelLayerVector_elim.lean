import Mathlib

set_option pp.all true
-- spec: Something.LLModelLayerVector.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 17) -> (motive Something.LLModelLayerVector) -> (motive t)
def Something.LLModelLayerVector.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 17) -> (motive Something.LLModelLayerVector) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 17) (LLModelLayerVector : motive Something.LLModelLayerVector) => Something.ctorElim.{u} motive 17 t (Eq.symm.{1} Nat (Something.ctorIdx t) 17 h) (PULift.up.{u, u} (motive Something.LLModelLayerVector) LLModelLayerVector)
