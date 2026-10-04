import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.Context.ref : Lean.Elab.Command.Context -> Lean.Syntax
def Lean.Elab.Command.Context.ref : Lean.Elab.Command.Context -> Lean.Syntax :=
  fun (self : Lean.Elab.Command.Context) => self.8
