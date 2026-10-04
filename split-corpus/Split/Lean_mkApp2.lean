import Mathlib

set_option pp.all true
-- spec: Lean.mkApp2 : Lean.Expr -> Lean.Expr -> Lean.Expr -> Lean.Expr
def Lean.mkApp2 : Lean.Expr -> Lean.Expr -> Lean.Expr -> Lean.Expr :=
  fun (f : Lean.Expr) (a : Lean.Expr) (b : Lean.Expr) => Lean.mkAppB f a b
