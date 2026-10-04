import Mathlib

set_option pp.all true
-- spec: Something.LLModelLayerVectorNeuron.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 18) -> (motive Something.LLModelLayerVectorNeuron) -> (motive t)
def Something.LLModelLayerVectorNeuron.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 18) -> (motive Something.LLModelLayerVectorNeuron) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 18) (LLModelLayerVectorNeuron : motive Something.LLModelLayerVectorNeuron) => Something.ctorElim.{u} motive 18 t (Eq.symm.{1} Nat (Something.ctorIdx t) 18 h) (PULift.up.{u, u} (motive Something.LLModelLayerVectorNeuron) LLModelLayerVectorNeuron)
