import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.Scope.currNamespace : Lean.Elab.Command.Scope -> Lean.Name
def Lean.Elab.Command.Scope.currNamespace : Lean.Elab.Command.Scope -> Lean.Name :=
  fun (self : Lean.Elab.Command.Scope) => self.3
