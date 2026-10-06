import Mathlib

set_option pp.all true
-- spec: Lean.NameSanitizerState.options : Lean.NameSanitizerState -> Lean.Options
def Lean.NameSanitizerState.options : Lean.NameSanitizerState -> Lean.Options :=
  fun (self : Lean.NameSanitizerState) => self.1
