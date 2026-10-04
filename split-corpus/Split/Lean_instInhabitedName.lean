import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedName : Inhabited.{1} Lean.Name
def Lean.instInhabitedName : Inhabited.{1} Lean.Name :=
  Inhabited.mk.{1} Lean.Name Lean.Name.anonymous
