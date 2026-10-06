import Mathlib

set_option pp.all true
-- spec: Something.ThatLMQueryInBeingProcessedByLLM.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 11) -> (motive Something.ThatLMQueryInBeingProcessedByLLM) -> (motive t)
def Something.ThatLMQueryInBeingProcessedByLLM.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 11) -> (motive Something.ThatLMQueryInBeingProcessedByLLM) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 11) (ThatLMQueryInBeingProcessedByLLM : motive Something.ThatLMQueryInBeingProcessedByLLM) => Something.ctorElim.{u} motive 11 t (Eq.symm.{1} Nat (Something.ctorIdx t) 11 h) (PULift.up.{u, u} (motive Something.ThatLMQueryInBeingProcessedByLLM) ThatLMQueryInBeingProcessedByLLM)
