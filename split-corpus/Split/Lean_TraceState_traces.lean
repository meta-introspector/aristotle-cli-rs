import Mathlib

set_option pp.all true
-- spec: Lean.TraceState.traces : Lean.TraceState -> (Lean.PersistentArray.{0} Lean.TraceElem)
def Lean.TraceState.traces : Lean.TraceState -> (Lean.PersistentArray.{0} Lean.TraceElem) :=
  fun (self : Lean.TraceState) => self.2
