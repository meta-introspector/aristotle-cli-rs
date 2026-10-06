import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedLevel : Inhabited.{1} Lean.Level
def Lean.instInhabitedLevel : Inhabited.{1} Lean.Level :=
  Inhabited.mk.{1} Lean.Level Lean.instInhabitedLevel.default
