import Mathlib

set_option pp.all true
-- spec: Lean.Core.Context.cancelTk? : Lean.Core.Context -> (Option.{0} IO.CancelToken)
def Lean.Core.Context.cancelTk? : Lean.Core.Context -> (Option.{0} IO.CancelToken) :=
  fun (self : Lean.Core.Context) => self.14
