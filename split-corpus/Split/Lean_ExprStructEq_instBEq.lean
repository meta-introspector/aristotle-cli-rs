import Mathlib

set_option pp.all true
-- spec: Lean.ExprStructEq.instBEq : BEq.{0} Lean.ExprStructEq
def Lean.ExprStructEq.instBEq : BEq.{0} Lean.ExprStructEq :=
  BEq.mk.{0} Lean.ExprStructEq Lean.ExprStructEq.beq
