import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.State.scopes : Lean.Elab.Command.State -> (List.{0} Lean.Elab.Command.Scope)
def Lean.Elab.Command.State.scopes : Lean.Elab.Command.State -> (List.{0} Lean.Elab.Command.Scope) :=
  fun (self : Lean.Elab.Command.State) => self.3
