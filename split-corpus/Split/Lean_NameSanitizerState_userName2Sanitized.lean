import Mathlib

set_option pp.all true
-- spec: Lean.NameSanitizerState.userName2Sanitized : Lean.NameSanitizerState -> (Lean.NameMap Lean.Name)
def Lean.NameSanitizerState.userName2Sanitized : Lean.NameSanitizerState -> (Lean.NameMap Lean.Name) :=
  fun (self : Lean.NameSanitizerState) => self.3
