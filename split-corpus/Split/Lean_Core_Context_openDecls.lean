import Mathlib

set_option pp.all true
-- spec: Lean.Core.Context.openDecls : Lean.Core.Context -> (List.{0} Lean.OpenDecl)
def Lean.Core.Context.openDecls : Lean.Core.Context -> (List.{0} Lean.OpenDecl) :=
  fun (self : Lean.Core.Context) => self.8
