import Mathlib

set_option pp.all true
-- spec: Lean.Kernel.Environment.header : Lean.Kernel.Environment -> Lean.EnvironmentHeader
def Lean.Kernel.Environment.header : Lean.Kernel.Environment -> Lean.EnvironmentHeader :=
  fun (self : Lean.Kernel.Environment) => self.7
