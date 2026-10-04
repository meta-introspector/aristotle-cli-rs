import Mathlib

set_option pp.all true
-- spec: Lean.TraceState.tid : Lean.TraceState -> UInt64
def Lean.TraceState.tid : Lean.TraceState -> UInt64 :=
  fun (self : Lean.TraceState) => self.1
