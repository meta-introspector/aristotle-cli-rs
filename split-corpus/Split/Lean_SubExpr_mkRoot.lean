import Mathlib

set_option pp.all true
-- spec: Lean.SubExpr.mkRoot : Lean.Expr -> Lean.SubExpr
def Lean.SubExpr.mkRoot : Lean.Expr -> Lean.SubExpr :=
  fun (e : Lean.Expr) => Lean.SubExpr.mk e Lean.SubExpr.Pos.root
