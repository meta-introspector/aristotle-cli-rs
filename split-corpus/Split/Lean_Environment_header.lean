import Mathlib

set_option pp.all true
-- spec: Lean.Environment.header : Lean.Environment -> Lean.EnvironmentHeader
def Lean.Environment.header : Lean.Environment -> Lean.EnvironmentHeader :=
  fun (env : Lean.Environment) => Lean.Kernel.Environment.header (_private.Lean.Environment.0.Lean.VisibilityMap.private Lean.Kernel.Environment (_private.Lean.Environment.0.Lean.Environment.base env))
