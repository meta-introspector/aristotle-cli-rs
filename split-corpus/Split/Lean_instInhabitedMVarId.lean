import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedMVarId : Inhabited.{1} Lean.MVarId
def Lean.instInhabitedMVarId : Inhabited.{1} Lean.MVarId :=
  Inhabited.mk.{1} Lean.MVarId Lean.instInhabitedMVarId.default
