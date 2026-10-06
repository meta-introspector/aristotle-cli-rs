import Mathlib

set_option pp.all true
-- spec: Expr.LLMResponse.elim : forall {motive : Expr -> Sort.{u}} (t : Expr), (Eq.{1} Nat (Expr.ctorIdx t) 2) -> (forall (a._@._internal._hyg.0 : String), motive (Expr.LLMResponse a._@._internal._hyg.0)) -> (motive t)
def Expr.LLMResponse.elim : forall {motive : Expr -> Sort.{u}} (t : Expr), (Eq.{1} Nat (Expr.ctorIdx t) 2) -> (forall (a._@._internal._hyg.0 : String), motive (Expr.LLMResponse a._@._internal._hyg.0)) -> (motive t) :=
  fun {motive : Expr -> Sort.{u}} (t : Expr) (h : Eq.{1} Nat (Expr.ctorIdx t) 2) (LLMResponse : forall (a._@._internal._hyg.0 : String), motive (Expr.LLMResponse a._@._internal._hyg.0)) => Expr.ctorElim.{u} motive 2 t (Eq.symm.{1} Nat (Expr.ctorIdx t) 2 h) (PULift.up.{u, u} (forall (a._@._internal._hyg.0 : String), motive (Expr.LLMResponse a._@._internal._hyg.0)) LLMResponse)
