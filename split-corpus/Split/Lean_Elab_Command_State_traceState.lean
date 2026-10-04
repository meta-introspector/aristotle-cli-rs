import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.State.traceState : Lean.Elab.Command.State -> Lean.TraceState
def Lean.Elab.Command.State.traceState : Lean.Elab.Command.State -> Lean.TraceState :=
  fun (self : Lean.Elab.Command.State) => self.10
