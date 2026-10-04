import Mathlib

set_option pp.all true
-- spec: Lean.Meta.DiagSummary.data : Lean.Meta.DiagSummary -> (Array.{0} Lean.MessageData)
def Lean.Meta.DiagSummary.data : Lean.Meta.DiagSummary -> (Array.{0} Lean.MessageData) :=
  fun (self : Lean.Meta.DiagSummary) => self.1
