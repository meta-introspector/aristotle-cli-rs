import Mathlib

set_option pp.all true
-- spec: Lean.PPContext.mctx : Lean.PPContext -> Lean.MetavarContext
def Lean.PPContext.mctx : Lean.PPContext -> Lean.MetavarContext :=
  fun (self : Lean.PPContext) => self.2
