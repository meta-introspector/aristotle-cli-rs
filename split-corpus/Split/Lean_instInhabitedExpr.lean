import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedExpr : Inhabited.{1} Lean.Expr
def Lean.instInhabitedExpr : Inhabited.{1} Lean.Expr :=
  Inhabited.mk.{1} Lean.Expr (Lean.Expr.const (Lean.Name.mkStr1 "_inhabitedExprDummy") (List.nil.{0} Lean.Level))
