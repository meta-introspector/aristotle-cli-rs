import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.Context.cmdPos : Lean.Elab.Command.Context -> String.Pos.Raw
def Lean.Elab.Command.Context.cmdPos : Lean.Elab.Command.Context -> String.Pos.Raw :=
  fun (self : Lean.Elab.Command.Context) => self.4
