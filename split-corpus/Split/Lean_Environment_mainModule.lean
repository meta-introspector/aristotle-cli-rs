import Mathlib

set_option pp.all true
-- spec: Lean.Environment.mainModule : Lean.Environment -> Lean.Name
def Lean.Environment.mainModule : Lean.Environment -> Lean.Name :=
  fun (env : Lean.Environment) => Lean.EnvironmentHeader.mainModule (Lean.Environment.header env)
