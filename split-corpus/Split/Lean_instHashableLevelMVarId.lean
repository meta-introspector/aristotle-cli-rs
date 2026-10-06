import Mathlib

set_option pp.all true
-- spec: Lean.instHashableLevelMVarId : Hashable.{1} Lean.LevelMVarId
def Lean.instHashableLevelMVarId : Hashable.{1} Lean.LevelMVarId :=
  Hashable.mk.{1} Lean.LevelMVarId Lean.instHashableLevelMVarId.hash
