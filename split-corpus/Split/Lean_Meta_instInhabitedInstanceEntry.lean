import Mathlib

set_option pp.all true
-- spec: Lean.Meta.instInhabitedInstanceEntry : Inhabited.{1} Lean.Meta.InstanceEntry
def Lean.Meta.instInhabitedInstanceEntry : Inhabited.{1} Lean.Meta.InstanceEntry :=
  Inhabited.mk.{1} Lean.Meta.InstanceEntry Lean.Meta.instInhabitedInstanceEntry.default
