import Mathlib

set_option pp.all true
-- spec: Lean.instBEqLiteral : BEq.{0} Lean.Literal
def Lean.instBEqLiteral : BEq.{0} Lean.Literal :=
  BEq.mk.{0} Lean.Literal Lean.instBEqLiteral.beq
