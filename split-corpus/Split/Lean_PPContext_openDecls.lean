import Mathlib

set_option pp.all true
-- spec: Lean.PPContext.openDecls : Lean.PPContext -> (List.{0} Lean.OpenDecl)
def Lean.PPContext.openDecls : Lean.PPContext -> (List.{0} Lean.OpenDecl) :=
  fun (self : Lean.PPContext) => self.6
