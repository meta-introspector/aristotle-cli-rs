import Mathlib

set_option pp.all true
-- spec: Lean.PPContext.currNamespace : Lean.PPContext -> Lean.Name
def Lean.PPContext.currNamespace : Lean.PPContext -> Lean.Name :=
  fun (self : Lean.PPContext) => self.5
