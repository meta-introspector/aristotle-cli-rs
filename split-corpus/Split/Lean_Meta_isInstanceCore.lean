import Mathlib

set_option pp.all true
-- spec: Lean.Meta.isInstanceCore : Lean.Environment -> Lean.Name -> Bool
def Lean.Meta.isInstanceCore : Lean.Environment -> Lean.Name -> Bool :=
  fun (env : Lean.Environment) (declName : Lean.Name) => Lean.PersistentHashMap.contains.{0, 0} Lean.Name Lean.Meta.InstanceEntry Lean.Name.instBEq Lean.instHashableName (Lean.Meta.Instances.instanceNames (Lean.ScopedEnvExtension.getState Lean.Meta.Instances Lean.Meta.InstanceEntry Lean.Meta.InstanceEntry Lean.Meta.instInhabitedInstances Lean.Meta.instanceExtension env (Lean.EnvExtension.asyncMode (Lean.PersistentEnvExtensionState (Lean.ScopedEnvExtension.Entry Lean.Meta.InstanceEntry) (Lean.ScopedEnvExtension.StateStack Lean.Meta.InstanceEntry Lean.Meta.InstanceEntry Lean.Meta.Instances)) (Lean.PersistentEnvExtension.toEnvExtension (Lean.ScopedEnvExtension.Entry Lean.Meta.InstanceEntry) (Lean.ScopedEnvExtension.Entry Lean.Meta.InstanceEntry) (Lean.ScopedEnvExtension.StateStack Lean.Meta.InstanceEntry Lean.Meta.InstanceEntry Lean.Meta.Instances) (Lean.ScopedEnvExtension.ext Lean.Meta.InstanceEntry Lean.Meta.InstanceEntry Lean.Meta.Instances Lean.Meta.instanceExtension))))) declName
