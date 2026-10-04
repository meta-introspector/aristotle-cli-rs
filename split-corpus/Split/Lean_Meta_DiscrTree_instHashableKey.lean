import Mathlib

set_option pp.all true
-- spec: Lean.Meta.DiscrTree.instHashableKey : Hashable.{1} Lean.Meta.DiscrTree.Key
def Lean.Meta.DiscrTree.instHashableKey : Hashable.{1} Lean.Meta.DiscrTree.Key :=
  Hashable.mk.{1} Lean.Meta.DiscrTree.Key Lean.Meta.DiscrTree.Key.hash
