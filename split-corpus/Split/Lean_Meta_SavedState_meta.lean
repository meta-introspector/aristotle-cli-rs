import Mathlib

set_option pp.all true
-- spec: Lean.Meta.SavedState.meta : Lean.Meta.SavedState -> Lean.Meta.State
def Lean.Meta.SavedState.meta : Lean.Meta.SavedState -> Lean.Meta.State :=
  fun (self : Lean.Meta.SavedState) => self.2
