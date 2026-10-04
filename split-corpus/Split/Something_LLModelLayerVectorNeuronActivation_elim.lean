import Mathlib

set_option pp.all true
-- spec: Something.LLModelLayerVectorNeuronActivation.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 19) -> (motive Something.LLModelLayerVectorNeuronActivation) -> (motive t)
def Something.LLModelLayerVectorNeuronActivation.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 19) -> (motive Something.LLModelLayerVectorNeuronActivation) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 19) (LLModelLayerVectorNeuronActivation : motive Something.LLModelLayerVectorNeuronActivation) => Something.ctorElim.{u} motive 19 t (Eq.symm.{1} Nat (Something.ctorIdx t) 19 h) (PULift.up.{u, u} (motive Something.LLModelLayerVectorNeuronActivation) LLModelLayerVectorNeuronActivation)
