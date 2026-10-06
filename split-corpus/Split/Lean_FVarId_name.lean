import Mathlib

set_option pp.all true
-- spec: Lean.FVarId.name : Lean.FVarId -> Lean.Name
def Lean.FVarId.name : Lean.FVarId -> Lean.Name :=
  fun (self : Lean.FVarId) => self.1
