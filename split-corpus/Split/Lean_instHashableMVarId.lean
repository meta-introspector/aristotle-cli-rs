import Mathlib

set_option pp.all true
-- spec: Lean.instHashableMVarId : Hashable.{1} Lean.MVarId
def Lean.instHashableMVarId : Hashable.{1} Lean.MVarId :=
  Hashable.mk.{1} Lean.MVarId Lean.instHashableMVarId.hash
