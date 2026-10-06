import Mathlib

set_option pp.all true
-- spec: Lean.Meta.instInhabitedInstances : Inhabited.{1} Lean.Meta.Instances
def Lean.Meta.instInhabitedInstances : Inhabited.{1} Lean.Meta.Instances :=
  Inhabited.mk.{1} Lean.Meta.Instances Lean.Meta.instInhabitedInstances.default
