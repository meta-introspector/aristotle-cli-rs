import Mathlib

set_option pp.all true
-- spec: Lean.instHashableFVarId : Hashable.{1} Lean.FVarId
def Lean.instHashableFVarId : Hashable.{1} Lean.FVarId :=
  Hashable.mk.{1} Lean.FVarId Lean.instHashableFVarId.hash
