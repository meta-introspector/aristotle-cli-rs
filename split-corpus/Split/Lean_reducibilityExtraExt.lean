import Mathlib

-- spec: opaque Lean.reducibilityExtraExt : Lean.SimpleScopedEnvExtension (Prod.{0, 0} Lean.Name Lean.ReducibilityStatus) (Lean.SMap.{0, 0} Lean.Name Lean.ReducibilityStatus Lean.Name.instBEq Lean.instHashableName)
opaque Lean.reducibilityExtraExt : Lean.SimpleScopedEnvExtension (Prod.{0, 0} Lean.Name Lean.ReducibilityStatus) (Lean.SMap.{0, 0} Lean.Name Lean.ReducibilityStatus Lean.Name.instBEq Lean.instHashableName) :=
  Inhabited.default.{1} (Lean.SimpleScopedEnvExtension (Prod.{0, 0} Lean.Name Lean.ReducibilityStatus) (Lean.SMap.{0, 0} Lean.Name Lean.ReducibilityStatus Lean.Name.instBEq Lean.instHashableName)) (Lean.instInhabitedScopedEnvExtension (Prod.{0, 0} Lean.Name Lean.ReducibilityStatus) (instInhabitedProd.{0, 0} Lean.Name Lean.ReducibilityStatus Lean.instInhabitedName Lean.instInhabitedReducibilityStatus) (Prod.{0, 0} Lean.Name Lean.ReducibilityStatus) (Lean.SMap.{0, 0} Lean.Name Lean.ReducibilityStatus Lean.Name.instBEq Lean.instHashableName))
