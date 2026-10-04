import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Instances.discrTree : Lean.Meta.Instances -> Lean.Meta.InstanceTree
def Lean.Meta.Instances.discrTree : Lean.Meta.Instances -> Lean.Meta.InstanceTree :=
  fun (self : Lean.Meta.Instances) => self.1
