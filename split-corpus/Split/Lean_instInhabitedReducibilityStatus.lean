import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedReducibilityStatus : Inhabited.{1} Lean.ReducibilityStatus
def Lean.instInhabitedReducibilityStatus : Inhabited.{1} Lean.ReducibilityStatus :=
  Inhabited.mk.{1} Lean.ReducibilityStatus Lean.instInhabitedReducibilityStatus.default
