import Mathlib

set_option pp.all true
-- spec: Lean.NameSanitizerState.nameStem2Idx : Lean.NameSanitizerState -> (Lean.NameMap Nat)
def Lean.NameSanitizerState.nameStem2Idx : Lean.NameSanitizerState -> (Lean.NameMap Nat) :=
  fun (self : Lean.NameSanitizerState) => self.2
