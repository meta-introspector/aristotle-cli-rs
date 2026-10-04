import Mathlib

set_option pp.all true
-- spec: Lean.Kernel.isDiagnosticsEnabled : Lean.Environment -> Bool
def Lean.Kernel.isDiagnosticsEnabled : Lean.Environment -> Bool :=
  fun (env : Lean.Environment) => Lean.Kernel.Environment.isDiagnosticsEnabled (_private.Lean.Environment.0.Lean.VisibilityMap.private Lean.Kernel.Environment (_private.Lean.Environment.0.Lean.Environment.base env))
