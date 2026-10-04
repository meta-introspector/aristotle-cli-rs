import Mathlib

-- spec: opaque Lean.Meta.instanceExtension : Lean.SimpleScopedEnvExtension Lean.Meta.InstanceEntry Lean.Meta.Instances
opaque Lean.Meta.instanceExtension : Lean.SimpleScopedEnvExtension Lean.Meta.InstanceEntry Lean.Meta.Instances :=
  Inhabited.default.{1} (Lean.SimpleScopedEnvExtension Lean.Meta.InstanceEntry Lean.Meta.Instances) (Lean.instInhabitedScopedEnvExtension Lean.Meta.InstanceEntry Lean.Meta.instInhabitedInstanceEntry Lean.Meta.InstanceEntry Lean.Meta.Instances)
