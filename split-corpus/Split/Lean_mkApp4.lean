import Mathlib

set_option pp.all true
-- spec: Lean.mkApp4 : Lean.Expr -> Lean.Expr -> Lean.Expr -> Lean.Expr -> Lean.Expr -> Lean.Expr
def Lean.mkApp4 : Lean.Expr -> Lean.Expr -> Lean.Expr -> Lean.Expr -> Lean.Expr -> Lean.Expr :=
  fun (f : Lean.Expr) (a : Lean.Expr) (b : Lean.Expr) (c : Lean.Expr) (d : Lean.Expr) => Lean.mkAppB (Lean.mkAppB f a b) c d
