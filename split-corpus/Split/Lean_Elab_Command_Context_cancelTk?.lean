import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.Context.cancelTk? : Lean.Elab.Command.Context -> (Option.{0} IO.CancelToken)
def Lean.Elab.Command.Context.cancelTk? : Lean.Elab.Command.Context -> (Option.{0} IO.CancelToken) :=
  fun (self : Lean.Elab.Command.Context) => self.10
