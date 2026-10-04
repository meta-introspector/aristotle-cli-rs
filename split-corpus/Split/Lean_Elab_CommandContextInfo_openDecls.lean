import Mathlib

set_option pp.all true
-- spec: Lean.Elab.CommandContextInfo.openDecls : Lean.Elab.CommandContextInfo -> (List.{0} Lean.OpenDecl)
def Lean.Elab.CommandContextInfo.openDecls : Lean.Elab.CommandContextInfo -> (List.{0} Lean.OpenDecl) :=
  fun (self : Lean.Elab.CommandContextInfo) => self.7
