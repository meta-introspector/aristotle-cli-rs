import Mathlib

set_option pp.all true
-- spec: Expr.QuotedCode.noConfusion : forall {P : Sort.{u}} {a._@._internal._hyg.0 : Expr} {a'._@._internal._hyg.0 : Expr}, (Eq.{1} Expr (Expr.QuotedCode a._@._internal._hyg.0) (Expr.QuotedCode a'._@._internal._hyg.0)) -> ((Eq.{1} Expr a._@._internal._hyg.0 a'._@._internal._hyg.0) -> P) -> P
def Expr.QuotedCode.noConfusion : forall {P : Sort.{u}} {a._@._internal._hyg.0 : Expr} {a'._@._internal._hyg.0 : Expr}, (Eq.{1} Expr (Expr.QuotedCode a._@._internal._hyg.0) (Expr.QuotedCode a'._@._internal._hyg.0)) -> ((Eq.{1} Expr a._@._internal._hyg.0 a'._@._internal._hyg.0) -> P) -> P :=
  fun {P : Sort.{u}} {a._@._internal._hyg.0 : Expr} {a'._@._internal._hyg.0 : Expr} (eq : Eq.{1} Expr (Expr.QuotedCode a._@._internal._hyg.0) (Expr.QuotedCode a'._@._internal._hyg.0)) (k : (Eq.{1} Expr a._@._internal._hyg.0 a'._@._internal._hyg.0) -> P) => id.{u} P (Expr.noConfusion.{u} P (Expr.QuotedCode a._@._internal._hyg.0) (Expr.QuotedCode a'._@._internal._hyg.0) eq k)
