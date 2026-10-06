import Mathlib

set_option pp.all true
-- spec: Lean.mkFVar : Lean.FVarId -> Lean.Expr
def Lean.mkFVar : Lean.FVarId -> Lean.Expr :=
  fun (fvarId : Lean.FVarId) => Lean.Expr.fvar fvarId
