import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.State.auxDeclNGen : Lean.Elab.Command.State -> Lean.DeclNameGenerator
def Lean.Elab.Command.State.auxDeclNGen : Lean.Elab.Command.State -> Lean.DeclNameGenerator :=
  fun (self : Lean.Elab.Command.State) => self.8
