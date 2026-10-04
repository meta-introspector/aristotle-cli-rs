import Mathlib

set_option pp.all true
-- spec: Lean.Meta.InstanceTree : Type
def Lean.Meta.InstanceTree : Type :=
  Lean.Meta.DiscrTree Lean.Meta.InstanceEntry
