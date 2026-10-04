import Mathlib

set_option pp.all true
-- spec: Lean.PPContext.lctx : Lean.PPContext -> Lean.LocalContext
def Lean.PPContext.lctx : Lean.PPContext -> Lean.LocalContext :=
  fun (self : Lean.PPContext) => self.3
