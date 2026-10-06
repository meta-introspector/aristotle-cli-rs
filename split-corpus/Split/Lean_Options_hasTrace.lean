import Mathlib

set_option pp.all true
-- spec: Lean.Options.hasTrace : Lean.Options -> Bool
def Lean.Options.hasTrace : Lean.Options -> Bool :=
  fun (self : Lean.Options) => self.2
