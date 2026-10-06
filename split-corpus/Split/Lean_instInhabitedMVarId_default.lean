import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedMVarId.default : Lean.MVarId
def Lean.instInhabitedMVarId.default : Lean.MVarId :=
  Lean.MVarId.mk (Inhabited.default.{1} Lean.Name Lean.instInhabitedName)
