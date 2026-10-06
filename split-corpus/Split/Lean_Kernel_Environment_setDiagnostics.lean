import Mathlib

set_option pp.all true
-- spec: Lean.Kernel.Environment.setDiagnostics : Lean.Kernel.Environment -> Lean.Kernel.Diagnostics -> Lean.Kernel.Environment
def Lean.Kernel.Environment.setDiagnostics : Lean.Kernel.Environment -> Lean.Kernel.Diagnostics -> Lean.Kernel.Environment :=
  fun (env : Lean.Kernel.Environment) (diag : Lean.Kernel.Diagnostics) => _private.Lean.Environment.0.Lean.Kernel.Environment.mk (Lean.Kernel.Environment.constants env) (Lean.Kernel.Environment.quotInit env) diag (Lean.Kernel.Environment.const2ModIdx env) (_private.Lean.Environment.0.Lean.Kernel.Environment.extensions env) (_private.Lean.Environment.0.Lean.Kernel.Environment.irBaseExts env) (Lean.Kernel.Environment.header env)
