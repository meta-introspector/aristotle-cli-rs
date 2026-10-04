import Mathlib

set_option pp.all true
-- spec: Lean.Expr.instToString : ToString.{0} Lean.Expr
def Lean.Expr.instToString : ToString.{0} Lean.Expr :=
  ToString.mk.{0} Lean.Expr Lean.Expr.dbgToString
