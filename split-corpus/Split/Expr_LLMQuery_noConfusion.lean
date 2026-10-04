import Mathlib

set_option pp.all true
-- spec: Expr.LLMQuery.noConfusion : forall {P : Sort.{u}} {a._@._internal._hyg.0 : String} {a'._@._internal._hyg.0 : String}, (Eq.{1} Expr (Expr.LLMQuery a._@._internal._hyg.0) (Expr.LLMQuery a'._@._internal._hyg.0)) -> ((Eq.{1} String a._@._internal._hyg.0 a'._@._internal._hyg.0) -> P) -> P
def Expr.LLMQuery.noConfusion : forall {P : Sort.{u}} {a._@._internal._hyg.0 : String} {a'._@._internal._hyg.0 : String}, (Eq.{1} Expr (Expr.LLMQuery a._@._internal._hyg.0) (Expr.LLMQuery a'._@._internal._hyg.0)) -> ((Eq.{1} String a._@._internal._hyg.0 a'._@._internal._hyg.0) -> P) -> P :=
  fun {P : Sort.{u}} {a._@._internal._hyg.0 : String} {a'._@._internal._hyg.0 : String} (eq : Eq.{1} Expr (Expr.LLMQuery a._@._internal._hyg.0) (Expr.LLMQuery a'._@._internal._hyg.0)) (k : (Eq.{1} String a._@._internal._hyg.0 a'._@._internal._hyg.0) -> P) => id.{u} P (Expr.noConfusion.{u} P (Expr.LLMQuery a._@._internal._hyg.0) (Expr.LLMQuery a'._@._internal._hyg.0) eq k)
