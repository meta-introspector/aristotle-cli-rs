import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.Scope.openDecls : Lean.Elab.Command.Scope -> (List.{0} Lean.OpenDecl)
def Lean.Elab.Command.Scope.openDecls : Lean.Elab.Command.Scope -> (List.{0} Lean.OpenDecl) :=
  fun (self : Lean.Elab.Command.Scope) => self.4
