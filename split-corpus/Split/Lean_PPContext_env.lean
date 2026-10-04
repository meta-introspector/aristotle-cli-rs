import Mathlib

set_option pp.all true
-- spec: Lean.PPContext.env : Lean.PPContext -> Lean.Environment
def Lean.PPContext.env : Lean.PPContext -> Lean.Environment :=
  fun (self : Lean.PPContext) => self.1
