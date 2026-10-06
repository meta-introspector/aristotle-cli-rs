import Mathlib

set_option pp.all true
-- spec: Lean.mkAppB : Lean.Expr -> Lean.Expr -> Lean.Expr -> Lean.Expr
def Lean.mkAppB : Lean.Expr -> Lean.Expr -> Lean.Expr -> Lean.Expr :=
  fun (f : Lean.Expr) (a : Lean.Expr) (b : Lean.Expr) => Lean.mkApp (Lean.mkApp f a) b
