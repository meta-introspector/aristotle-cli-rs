import Mathlib

set_option pp.all true
-- spec: Lean.Elab.CommandContextInfo.cmdEnv? : Lean.Elab.CommandContextInfo -> (Option.{0} Lean.Environment)
def Lean.Elab.CommandContextInfo.cmdEnv? : Lean.Elab.CommandContextInfo -> (Option.{0} Lean.Environment) :=
  fun (self : Lean.Elab.CommandContextInfo) => self.2
