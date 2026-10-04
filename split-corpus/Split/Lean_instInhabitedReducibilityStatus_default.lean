import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedReducibilityStatus.default : Lean.ReducibilityStatus
def Lean.instInhabitedReducibilityStatus.default : Lean.ReducibilityStatus :=
  Lean.ReducibilityStatus.reducible
