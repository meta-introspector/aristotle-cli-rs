import Mathlib

set_option pp.all true
-- spec: Lean.instHashableName : Hashable.{1} Lean.Name
def Lean.instHashableName : Hashable.{1} Lean.Name :=
  Hashable.mk.{1} Lean.Name Lean.Name.hash
