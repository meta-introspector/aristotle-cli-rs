import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Instances.instanceNames : Lean.Meta.Instances -> (Lean.PHashMap.{0, 0} Lean.Name Lean.Meta.InstanceEntry Lean.Name.instBEq Lean.instHashableName)
def Lean.Meta.Instances.instanceNames : Lean.Meta.Instances -> (Lean.PHashMap.{0, 0} Lean.Name Lean.Meta.InstanceEntry Lean.Name.instBEq Lean.instHashableName) :=
  fun (self : Lean.Meta.Instances) => self.2
