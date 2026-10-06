import Mathlib

set_option pp.all true
-- spec: Lean.Meta.SavedState.core : Lean.Meta.SavedState -> Lean.Core.SavedState
def Lean.Meta.SavedState.core : Lean.Meta.SavedState -> Lean.Core.SavedState :=
  fun (self : Lean.Meta.SavedState) => self.1
