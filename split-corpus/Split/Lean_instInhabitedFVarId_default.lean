import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedFVarId.default : Lean.FVarId
def Lean.instInhabitedFVarId.default : Lean.FVarId :=
  Lean.FVarId.mk (Inhabited.default.{1} Lean.Name Lean.instInhabitedName)
