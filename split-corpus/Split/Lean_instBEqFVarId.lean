import Mathlib

set_option pp.all true
-- spec: Lean.instBEqFVarId : BEq.{0} Lean.FVarId
def Lean.instBEqFVarId : BEq.{0} Lean.FVarId :=
  BEq.mk.{0} Lean.FVarId Lean.instBEqFVarId.beq
