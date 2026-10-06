import Mathlib

set_option pp.all true
-- spec: Lean.Meta.InstanceKey : Type
def Lean.Meta.InstanceKey : Type :=
  Lean.Meta.DiscrTree.Key
