import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.Context.quotContext? : Lean.Elab.Command.Context -> (Option.{0} Lean.Name)
def Lean.Elab.Command.Context.quotContext? : Lean.Elab.Command.Context -> (Option.{0} Lean.Name) :=
  fun (self : Lean.Elab.Command.Context) => self.6
