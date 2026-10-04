import Mathlib

set_option pp.all true
-- spec: Lean.Kernel.Environment.isDiagnosticsEnabled : Lean.Kernel.Environment -> Bool
def Lean.Kernel.Environment.isDiagnosticsEnabled : Lean.Kernel.Environment -> Bool :=
  fun (env : Lean.Kernel.Environment) => Lean.Kernel.Diagnostics.enabled (Lean.Kernel.Environment.diagnostics env)
