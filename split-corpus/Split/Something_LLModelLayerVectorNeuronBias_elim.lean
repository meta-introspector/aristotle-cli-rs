import Mathlib

set_option pp.all true
-- spec: Something.LLModelLayerVectorNeuronBias.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 20) -> (motive Something.LLModelLayerVectorNeuronBias) -> (motive t)
def Something.LLModelLayerVectorNeuronBias.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 20) -> (motive Something.LLModelLayerVectorNeuronBias) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 20) (LLModelLayerVectorNeuronBias : motive Something.LLModelLayerVectorNeuronBias) => Something.ctorElim.{u} motive 20 t (Eq.symm.{1} Nat (Something.ctorIdx t) 20 h) (PULift.up.{u, u} (motive Something.LLModelLayerVectorNeuronBias) LLModelLayerVectorNeuronBias)
