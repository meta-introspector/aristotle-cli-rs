import Mathlib

set_option pp.all true
-- spec: Lean.Meta.DiagSummary.isEmpty : Lean.Meta.DiagSummary -> Bool
def Lean.Meta.DiagSummary.isEmpty : Lean.Meta.DiagSummary -> Bool :=
  fun (s : Lean.Meta.DiagSummary) => Array.isEmpty.{0} Lean.MessageData (Lean.Meta.DiagSummary.data s)
