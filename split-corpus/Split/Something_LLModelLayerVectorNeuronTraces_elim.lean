import Mathlib

set_option pp.all true
-- spec: Something.LLModelLayerVectorNeuronTraces.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 23) -> (motive Something.LLModelLayerVectorNeuronTraces) -> (motive t)
def Something.LLModelLayerVectorNeuronTraces.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 23) -> (motive Something.LLModelLayerVectorNeuronTraces) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 23) (LLModelLayerVectorNeuronTraces : motive Something.LLModelLayerVectorNeuronTraces) => Something.ctorElim.{u} motive 23 t (Eq.symm.{1} Nat (Something.ctorIdx t) 23 h) (PULift.up.{u, u} (motive Something.LLModelLayerVectorNeuronTraces) LLModelLayerVectorNeuronTraces)
