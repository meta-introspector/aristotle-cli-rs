import Mathlib

-- spec: opaque Lean.aliasExtension : Lean.SimplePersistentEnvExtension Lean.AliasEntry Lean.AliasState
opaque Lean.aliasExtension : Lean.SimplePersistentEnvExtension Lean.AliasEntry Lean.AliasState :=
  Inhabited.default.{1} (Lean.SimplePersistentEnvExtension Lean.AliasEntry Lean.AliasState) (Lean.SimplePersistentEnvExtension.instInhabited Lean.AliasEntry Lean.AliasState (Lean.SMap.instInhabited.{0, 0} Lean.Name (List.{0} Lean.Name) Lean.Name.instBEq Lean.instHashableName))
