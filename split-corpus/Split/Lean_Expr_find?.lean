import Mathlib

set_option pp.all true
-- spec: Lean.Expr.find? : (Lean.Expr -> Bool) -> Lean.Expr -> (Option.{0} Lean.Expr)
def Lean.Expr.find? : (Lean.Expr -> Bool) -> Lean.Expr -> (Option.{0} Lean.Expr) :=
  fun (p : Lean.Expr -> Bool) (e : Lean.Expr) => Lean.Expr.findImpl? p e
