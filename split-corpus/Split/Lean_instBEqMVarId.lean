import Mathlib

set_option pp.all true
-- spec: Lean.instBEqMVarId : BEq.{0} Lean.MVarId
def Lean.instBEqMVarId : BEq.{0} Lean.MVarId :=
  BEq.mk.{0} Lean.MVarId Lean.instBEqMVarId.beq
