import Mathlib

set_option pp.all true
-- spec: Lean.PPContext.opts : Lean.PPContext -> Lean.Options
def Lean.PPContext.opts : Lean.PPContext -> Lean.Options :=
  fun (self : Lean.PPContext) => self.4
