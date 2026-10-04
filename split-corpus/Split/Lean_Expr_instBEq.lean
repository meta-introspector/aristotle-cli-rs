import Mathlib

set_option pp.all true
-- spec: Lean.Expr.instBEq : BEq.{0} Lean.Expr
def Lean.Expr.instBEq : BEq.{0} Lean.Expr :=
  BEq.mk.{0} Lean.Expr Lean.Expr.eqv
