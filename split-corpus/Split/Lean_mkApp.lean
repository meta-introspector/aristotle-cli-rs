import Mathlib

set_option pp.all true
-- spec: Lean.mkApp : Lean.Expr -> Lean.Expr -> Lean.Expr
def Lean.mkApp : Lean.Expr -> Lean.Expr -> Lean.Expr :=
  fun (f : Lean.Expr) (a : Lean.Expr) => Lean.Expr.app f a
