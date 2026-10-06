import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Instances.erased : Lean.Meta.Instances -> (Lean.PHashSet.{0} Lean.Name Lean.Name.instBEq Lean.instHashableName)
def Lean.Meta.Instances.erased : Lean.Meta.Instances -> (Lean.PHashSet.{0} Lean.Name Lean.Name.instBEq Lean.instHashableName) :=
  fun (self : Lean.Meta.Instances) => self.3
