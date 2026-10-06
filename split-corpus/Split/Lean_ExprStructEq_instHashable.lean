import Mathlib

set_option pp.all true
-- spec: Lean.ExprStructEq.instHashable : Hashable.{1} Lean.ExprStructEq
def Lean.ExprStructEq.instHashable : Hashable.{1} Lean.ExprStructEq :=
  Hashable.mk.{1} Lean.ExprStructEq Lean.ExprStructEq.hash
