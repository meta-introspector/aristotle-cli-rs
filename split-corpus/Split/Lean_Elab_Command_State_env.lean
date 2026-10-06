import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.State.env : Lean.Elab.Command.State -> Lean.Environment
def Lean.Elab.Command.State.env : Lean.Elab.Command.State -> Lean.Environment :=
  fun (self : Lean.Elab.Command.State) => self.1
