import Mathlib

set_option pp.all true
-- spec: Lean.Meta.DiagSummary.max : Lean.Meta.DiagSummary -> Nat
def Lean.Meta.DiagSummary.max : Lean.Meta.DiagSummary -> Nat :=
  fun (self : Lean.Meta.DiagSummary) => self.2
