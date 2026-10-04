import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.Scope.levelNames : Lean.Elab.Command.Scope -> (List.{0} Lean.Name)
def Lean.Elab.Command.Scope.levelNames : Lean.Elab.Command.Scope -> (List.{0} Lean.Name) :=
  fun (self : Lean.Elab.Command.Scope) => self.5
