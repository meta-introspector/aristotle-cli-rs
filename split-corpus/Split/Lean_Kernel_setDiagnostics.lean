import Mathlib

set_option pp.all true
-- spec: Lean.Kernel.setDiagnostics : Lean.Environment -> Lean.Kernel.Diagnostics -> Lean.Environment
def Lean.Kernel.setDiagnostics : Lean.Environment -> Lean.Kernel.Diagnostics -> Lean.Environment :=
  fun (env : Lean.Environment) (diag : Lean.Kernel.Diagnostics) => _private.Lean.Environment.0.Lean.Environment.modifyCheckedAsync env (fun (x._@.Lean.Environment.2488484649._hygCtx._hyg.8 : Lean.Kernel.Environment) => Lean.Kernel.Environment.setDiagnostics x._@.Lean.Environment.2488484649._hygCtx._hyg.8 diag)
