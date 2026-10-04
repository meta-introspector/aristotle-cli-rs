import Mathlib

set_option pp.all true
-- spec: Lean.Core.State.env : Lean.Core.State -> Lean.Environment
def Lean.Core.State.env : Lean.Core.State -> Lean.Environment :=
  fun (self : Lean.Core.State) => self.1
