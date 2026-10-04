import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.Context.suppressElabErrors : Lean.Elab.Command.Context -> Bool
def Lean.Elab.Command.Context.suppressElabErrors : Lean.Elab.Command.Context -> Bool :=
  fun (self : Lean.Elab.Command.Context) => self.11
