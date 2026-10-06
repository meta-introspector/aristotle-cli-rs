import Mathlib

set_option pp.all true
-- spec: Lean.mkSort : Lean.Level -> Lean.Expr
def Lean.mkSort : Lean.Level -> Lean.Expr :=
  fun (u : Lean.Level) => Lean.Expr.sort u
