import Mathlib

set_option pp.all true
-- spec: Lean.Expr.hasMVar : Lean.Expr -> Bool
def Lean.Expr.hasMVar : Lean.Expr -> Bool :=
  fun (e : Lean.Expr) => have d : Lean.Expr.Data := Lean.Expr.data e; Bool.or (Lean.Expr.Data.hasExprMVar d) (Lean.Expr.Data.hasLevelMVar d)
