import Mathlib

set_option pp.all true
-- spec: Lean.mkLit : Lean.Literal -> Lean.Expr
def Lean.mkLit : Lean.Literal -> Lean.Expr :=
  fun (l : Lean.Literal) => Lean.Expr.lit l
