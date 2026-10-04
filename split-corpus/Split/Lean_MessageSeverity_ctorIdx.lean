import Mathlib

set_option pp.all true
-- spec: Lean.MessageSeverity.ctorIdx : Lean.MessageSeverity -> Nat
def Lean.MessageSeverity.ctorIdx : Lean.MessageSeverity -> Nat :=
  fun (x : Lean.MessageSeverity) => Lean.MessageSeverity.casesOn.{1} (fun (x : Lean.MessageSeverity) => Nat) x 0 1 2
