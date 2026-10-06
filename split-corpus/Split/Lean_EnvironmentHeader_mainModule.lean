import Mathlib

set_option pp.all true
-- spec: Lean.EnvironmentHeader.mainModule : Lean.EnvironmentHeader -> Lean.Name
def Lean.EnvironmentHeader.mainModule : Lean.EnvironmentHeader -> Lean.Name :=
  fun (self : Lean.EnvironmentHeader) => self.2
