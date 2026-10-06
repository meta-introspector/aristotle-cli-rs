import Mathlib

set_option pp.all true
-- spec: Lean.Kernel.Environment.diagnostics : Lean.Kernel.Environment -> Lean.Kernel.Diagnostics
def Lean.Kernel.Environment.diagnostics : Lean.Kernel.Environment -> Lean.Kernel.Diagnostics :=
  fun (self : Lean.Kernel.Environment) => self.3
