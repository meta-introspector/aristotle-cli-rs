import Mathlib

set_option pp.all true
-- spec: Something.LLModelLayerVectorNeuronOutputs.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 22) -> (motive Something.LLModelLayerVectorNeuronOutputs) -> (motive t)
def Something.LLModelLayerVectorNeuronOutputs.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 22) -> (motive Something.LLModelLayerVectorNeuronOutputs) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 22) (LLModelLayerVectorNeuronOutputs : motive Something.LLModelLayerVectorNeuronOutputs) => Something.ctorElim.{u} motive 22 t (Eq.symm.{1} Nat (Something.ctorIdx t) 22 h) (PULift.up.{u, u} (motive Something.LLModelLayerVectorNeuronOutputs) LLModelLayerVectorNeuronOutputs)
