import Mathlib

-- spec: opaque Lean.indirectModUseExt : Lean.SimplePersistentEnvExtension Lean.IndirectModUse (Std.HashMap.{0, 0} Lean.Name (Array.{0} Lean.ModuleIdx) Lean.Name.instBEq Lean.instHashableName)
opaque Lean.indirectModUseExt : Lean.SimplePersistentEnvExtension Lean.IndirectModUse (Std.HashMap.{0, 0} Lean.Name (Array.{0} Lean.ModuleIdx) Lean.Name.instBEq Lean.instHashableName) :=
  Inhabited.default.{1} (Lean.SimplePersistentEnvExtension Lean.IndirectModUse (Std.HashMap.{0, 0} Lean.Name (Array.{0} Lean.ModuleIdx) Lean.Name.instBEq Lean.instHashableName)) (Lean.SimplePersistentEnvExtension.instInhabited Lean.IndirectModUse (Std.HashMap.{0, 0} Lean.Name (Array.{0} Lean.ModuleIdx) Lean.Name.instBEq Lean.instHashableName) (Std.HashMap.instInhabited.{0, 0} Lean.Name (Array.{0} Lean.ModuleIdx) Lean.Name.instBEq Lean.instHashableName))
