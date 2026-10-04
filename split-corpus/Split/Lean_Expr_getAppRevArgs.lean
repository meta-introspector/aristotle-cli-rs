import Mathlib

set_option pp.all true
-- spec: Lean.Expr.getAppRevArgs : Lean.Expr -> (Array.{0} Lean.Expr)
def Lean.Expr.getAppRevArgs : Lean.Expr -> (Array.{0} Lean.Expr) :=
  fun (e : Lean.Expr) => _private.Lean.Expr.0.Lean.Expr.getAppRevArgsAux e (Array.mkEmpty.{0} Lean.Expr (Lean.Expr.getAppNumArgs e))
