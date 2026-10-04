import Mathlib

set_option pp.all true
-- spec: Something.LLModelLayerVectorNeuronInputs.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 21) -> (motive Something.LLModelLayerVectorNeuronInputs) -> (motive t)
def Something.LLModelLayerVectorNeuronInputs.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 21) -> (motive Something.LLModelLayerVectorNeuronInputs) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 21) (LLModelLayerVectorNeuronInputs : motive Something.LLModelLayerVectorNeuronInputs) => Something.ctorElim.{u} motive 21 t (Eq.symm.{1} Nat (Something.ctorIdx t) 21 h) (PULift.up.{u, u} (motive Something.LLModelLayerVectorNeuronInputs) LLModelLayerVectorNeuronInputs)
