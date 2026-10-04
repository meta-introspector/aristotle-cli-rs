import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedFVarId : Inhabited.{1} Lean.FVarId
def Lean.instInhabitedFVarId : Inhabited.{1} Lean.FVarId :=
  Inhabited.mk.{1} Lean.FVarId Lean.instInhabitedFVarId.default
