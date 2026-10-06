import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.State.ngen : Lean.Elab.Command.State -> Lean.NameGenerator
def Lean.Elab.Command.State.ngen : Lean.Elab.Command.State -> Lean.NameGenerator :=
  fun (self : Lean.Elab.Command.State) => self.7
