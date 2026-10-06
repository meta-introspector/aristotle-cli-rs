import Mathlib

set_option pp.all true
-- spec: Lean.Elab.CommandContextInfo.env : Lean.Elab.CommandContextInfo -> Lean.Environment
def Lean.Elab.CommandContextInfo.env : Lean.Elab.CommandContextInfo -> Lean.Environment :=
  fun (self : Lean.Elab.CommandContextInfo) => self.1
