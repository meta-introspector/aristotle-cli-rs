import Mathlib

set_option pp.all true
-- spec: Lean.Level.instHashable : Hashable.{1} Lean.Level
def Lean.Level.instHashable : Hashable.{1} Lean.Level :=
  Hashable.mk.{1} Lean.Level Lean.Level.hash
