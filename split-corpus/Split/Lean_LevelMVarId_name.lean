import Mathlib

set_option pp.all true
-- spec: Lean.LevelMVarId.name : Lean.LevelMVarId -> Lean.Name
def Lean.LevelMVarId.name : Lean.LevelMVarId -> Lean.Name :=
  fun (self : Lean.LevelMVarId) => self.1
