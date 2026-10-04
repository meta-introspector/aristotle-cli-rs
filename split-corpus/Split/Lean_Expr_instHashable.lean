import Mathlib

set_option pp.all true
-- spec: Lean.Expr.instHashable : Hashable.{1} Lean.Expr
def Lean.Expr.instHashable : Hashable.{1} Lean.Expr :=
  Hashable.mk.{1} Lean.Expr Lean.Expr.hash
