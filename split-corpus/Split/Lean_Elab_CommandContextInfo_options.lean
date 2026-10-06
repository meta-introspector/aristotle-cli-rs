import Mathlib

set_option pp.all true
-- spec: Lean.Elab.CommandContextInfo.options : Lean.Elab.CommandContextInfo -> Lean.Options
def Lean.Elab.CommandContextInfo.options : Lean.Elab.CommandContextInfo -> Lean.Options :=
  fun (self : Lean.Elab.CommandContextInfo) => self.5
