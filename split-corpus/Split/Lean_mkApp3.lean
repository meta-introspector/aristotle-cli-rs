import Mathlib

set_option pp.all true
-- spec: Lean.mkApp3 : Lean.Expr -> Lean.Expr -> Lean.Expr -> Lean.Expr -> Lean.Expr
def Lean.mkApp3 : Lean.Expr -> Lean.Expr -> Lean.Expr -> Lean.Expr -> Lean.Expr :=
  fun (f : Lean.Expr) (a : Lean.Expr) (b : Lean.Expr) (c : Lean.Expr) => Lean.mkApp (Lean.mkAppB f a b) c
