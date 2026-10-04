import Mathlib

set_option pp.all true
-- spec: Lean.Elab.CommandContextInfo.mctx : Lean.Elab.CommandContextInfo -> Lean.MetavarContext
def Lean.Elab.CommandContextInfo.mctx : Lean.Elab.CommandContextInfo -> Lean.MetavarContext :=
  fun (self : Lean.Elab.CommandContextInfo) => self.4
