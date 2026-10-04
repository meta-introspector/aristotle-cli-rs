import Mathlib

set_option pp.all true
-- spec: Lean.Elab.CommandContextInfo.ngen : Lean.Elab.CommandContextInfo -> Lean.NameGenerator
def Lean.Elab.CommandContextInfo.ngen : Lean.Elab.CommandContextInfo -> Lean.NameGenerator :=
  fun (self : Lean.Elab.CommandContextInfo) => self.8
