import Mathlib

set_option pp.all true
-- spec: Lean.Core.Context.suppressElabErrors : Lean.Core.Context -> Bool
def Lean.Core.Context.suppressElabErrors : Lean.Core.Context -> Bool :=
  fun (self : Lean.Core.Context) => self.15
