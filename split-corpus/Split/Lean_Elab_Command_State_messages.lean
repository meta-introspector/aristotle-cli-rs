import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.State.messages : Lean.Elab.Command.State -> Lean.MessageLog
def Lean.Elab.Command.State.messages : Lean.Elab.Command.State -> Lean.MessageLog :=
  fun (self : Lean.Elab.Command.State) => self.2
