import Mathlib

set_option pp.all true
-- spec: Lean.Kernel.getDiagnostics : Lean.Environment -> Lean.Kernel.Diagnostics
def Lean.Kernel.getDiagnostics : Lean.Environment -> Lean.Kernel.Diagnostics :=
  fun (env : Lean.Environment) => Lean.Kernel.Environment.diagnostics (Task.get.{0} Lean.Kernel.Environment (Lean.Environment.checked env))
