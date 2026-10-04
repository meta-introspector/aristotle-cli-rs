import Mathlib

set_option pp.all true
-- spec: Lean.EnvironmentHeader.modules : Lean.EnvironmentHeader -> (Array.{0} Lean.EffectiveImport)
def Lean.EnvironmentHeader.modules : Lean.EnvironmentHeader -> (Array.{0} Lean.EffectiveImport) :=
  fun (self : Lean.EnvironmentHeader) => self.6
