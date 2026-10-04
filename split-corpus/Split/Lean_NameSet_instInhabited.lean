import Mathlib

set_option pp.all true
-- spec: Lean.NameSet.instInhabited : Inhabited.{1} Lean.NameSet
def Lean.NameSet.instInhabited : Inhabited.{1} Lean.NameSet :=
  Inhabited.mk.{1} Lean.NameSet Lean.NameSet.empty
