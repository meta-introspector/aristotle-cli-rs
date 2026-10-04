import Mathlib

set_option pp.all true
-- spec: Lean.SubExpr.expr : Lean.SubExpr -> Lean.Expr
def Lean.SubExpr.expr : Lean.SubExpr -> Lean.Expr :=
  fun (self : Lean.SubExpr) => self.1
