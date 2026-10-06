import Mathlib

set_option pp.all true
-- spec: Lean.EnvironmentHeader.isModule : Lean.EnvironmentHeader -> Bool
def Lean.EnvironmentHeader.isModule : Lean.EnvironmentHeader -> Bool :=
  fun (self : Lean.EnvironmentHeader) => self.3
