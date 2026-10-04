import Mathlib

set_option pp.all true
-- spec: InductiveFunction.LLMQuerying.elim : forall {motive : InductiveFunction -> Sort.{u}} (t : InductiveFunction), (Eq.{1} Nat (InductiveFunction.ctorIdx t) 0) -> (forall (a._@._internal._hyg.0 : Expr -> InductiveFunction), motive (InductiveFunction.LLMQuerying a._@._internal._hyg.0)) -> (motive t)
def InductiveFunction.LLMQuerying.elim : forall {motive : InductiveFunction -> Sort.{u}} (t : InductiveFunction), (Eq.{1} Nat (InductiveFunction.ctorIdx t) 0) -> (forall (a._@._internal._hyg.0 : Expr -> InductiveFunction), motive (InductiveFunction.LLMQuerying a._@._internal._hyg.0)) -> (motive t) :=
  fun {motive : InductiveFunction -> Sort.{u}} (t : InductiveFunction) (h : Eq.{1} Nat (InductiveFunction.ctorIdx t) 0) (LLMQuerying : forall (a._@._internal._hyg.0 : Expr -> InductiveFunction), motive (InductiveFunction.LLMQuerying a._@._internal._hyg.0)) => InductiveFunction.ctorElim.{u} motive 0 t (Eq.symm.{1} Nat (InductiveFunction.ctorIdx t) 0 h) (PULift.up.{u, u} (forall (a._@._internal._hyg.0 : Expr -> InductiveFunction), motive (InductiveFunction.LLMQuerying a._@._internal._hyg.0)) LLMQuerying)
