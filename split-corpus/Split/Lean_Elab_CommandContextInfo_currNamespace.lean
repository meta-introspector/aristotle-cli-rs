import Mathlib

set_option pp.all true
-- spec: Lean.Elab.CommandContextInfo.currNamespace : Lean.Elab.CommandContextInfo -> Lean.Name
def Lean.Elab.CommandContextInfo.currNamespace : Lean.Elab.CommandContextInfo -> Lean.Name :=
  fun (self : Lean.Elab.CommandContextInfo) => self.6
