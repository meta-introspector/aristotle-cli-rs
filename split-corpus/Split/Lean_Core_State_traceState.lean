import Mathlib

set_option pp.all true
-- spec: Lean.Core.State.traceState : Lean.Core.State -> Lean.TraceState
def Lean.Core.State.traceState : Lean.Core.State -> Lean.TraceState :=
  fun (self : Lean.Core.State) => self.5
