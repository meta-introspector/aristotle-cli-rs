import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.Context.fileName : Lean.Elab.Command.Context -> String
def Lean.Elab.Command.Context.fileName : Lean.Elab.Command.Context -> String :=
  fun (self : Lean.Elab.Command.Context) => self.1
