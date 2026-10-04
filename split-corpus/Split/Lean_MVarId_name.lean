import Mathlib

set_option pp.all true
-- spec: Lean.MVarId.name : Lean.MVarId -> Lean.Name
def Lean.MVarId.name : Lean.MVarId -> Lean.Name :=
  fun (self : Lean.MVarId) => self.1
