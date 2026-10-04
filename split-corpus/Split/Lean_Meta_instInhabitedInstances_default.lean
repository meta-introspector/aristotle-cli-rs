import Mathlib

set_option pp.all true
-- spec: Lean.Meta.instInhabitedInstances.default : Lean.Meta.Instances
def Lean.Meta.instInhabitedInstances.default : Lean.Meta.Instances :=
  Lean.Meta.Instances.mk (Inhabited.default.{1} Lean.Meta.InstanceTree (Lean.Meta.DiscrTree.instInhabited Lean.Meta.InstanceEntry)) (Inhabited.default.{1} (Lean.PHashMap.{0, 0} Lean.Name Lean.Meta.InstanceEntry Lean.Name.instBEq Lean.instHashableName) (Lean.PersistentHashMap.instInhabited.{0, 0} Lean.Name Lean.Meta.InstanceEntry Lean.Name.instBEq Lean.instHashableName)) (Inhabited.default.{1} (Lean.PHashSet.{0} Lean.Name Lean.Name.instBEq Lean.instHashableName) (Lean.PersistentHashSet.instInhabited.{0} Lean.Name Lean.Name.instBEq Lean.instHashableName))
