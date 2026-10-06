import Mathlib

set_option pp.all true
-- spec: Expr.LLMQuery.elim : forall {motive : Expr -> Sort.{u}} (t : Expr), (Eq.{1} Nat (Expr.ctorIdx t) 1) -> (forall (a._@._internal._hyg.0 : String), motive (Expr.LLMQuery a._@._internal._hyg.0)) -> (motive t)
def Expr.LLMQuery.elim : forall {motive : Expr -> Sort.{u}} (t : Expr), (Eq.{1} Nat (Expr.ctorIdx t) 1) -> (forall (a._@._internal._hyg.0 : String), motive (Expr.LLMQuery a._@._internal._hyg.0)) -> (motive t) :=
  fun {motive : Expr -> Sort.{u}} (t : Expr) (h : Eq.{1} Nat (Expr.ctorIdx t) 1) (LLMQuery : forall (a._@._internal._hyg.0 : String), motive (Expr.LLMQuery a._@._internal._hyg.0)) => Expr.ctorElim.{u} motive 1 t (Eq.symm.{1} Nat (Expr.ctorIdx t) 1 h) (PULift.up.{u, u} (forall (a._@._internal._hyg.0 : String), motive (Expr.LLMQuery a._@._internal._hyg.0)) LLMQuery)
