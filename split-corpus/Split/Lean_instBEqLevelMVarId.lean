import Mathlib

set_option pp.all true
-- spec: Lean.instBEqLevelMVarId : BEq.{0} Lean.LevelMVarId
def Lean.instBEqLevelMVarId : BEq.{0} Lean.LevelMVarId :=
  BEq.mk.{0} Lean.LevelMVarId Lean.instBEqLevelMVarId.beq
