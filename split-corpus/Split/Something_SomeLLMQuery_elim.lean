import Mathlib

set_option pp.all true
-- spec: Something.SomeLLMQuery.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 10) -> (motive Something.SomeLLMQuery) -> (motive t)
def Something.SomeLLMQuery.elim : forall {motive : Something -> Sort.{u}} (t : Something), (Eq.{1} Nat (Something.ctorIdx t) 10) -> (motive Something.SomeLLMQuery) -> (motive t) :=
  fun {motive : Something -> Sort.{u}} (t : Something) (h : Eq.{1} Nat (Something.ctorIdx t) 10) (SomeLLMQuery : motive Something.SomeLLMQuery) => Something.ctorElim.{u} motive 10 t (Eq.symm.{1} Nat (Something.ctorIdx t) 10 h) (PULift.up.{u, u} (motive Something.SomeLLMQuery) SomeLLMQuery)
