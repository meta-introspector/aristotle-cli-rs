import Mathlib

set_option pp.all true
-- spec: Lean.Core.SavedState.toState : Lean.Core.SavedState -> Lean.Core.State
def Lean.Core.SavedState.toState : Lean.Core.SavedState -> Lean.Core.State :=
  fun (self : Lean.Core.SavedState) => self.1
