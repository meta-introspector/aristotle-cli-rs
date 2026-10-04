import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.State.infoState : Lean.Elab.Command.State -> Lean.Elab.InfoState
def Lean.Elab.Command.State.infoState : Lean.Elab.Command.State -> Lean.Elab.InfoState :=
  fun (self : Lean.Elab.Command.State) => self.9
