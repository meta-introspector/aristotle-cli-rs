import Mathlib

-- spec: opaque Lean.reducibilityCoreExt : Lean.PersistentEnvExtension (Prod.{0, 0} Lean.Name Lean.ReducibilityStatus) (Prod.{0, 0} Lean.Name Lean.ReducibilityStatus) (Lean.NameMap Lean.ReducibilityStatus)
opaque Lean.reducibilityCoreExt : Lean.PersistentEnvExtension (Prod.{0, 0} Lean.Name Lean.ReducibilityStatus) (Prod.{0, 0} Lean.Name Lean.ReducibilityStatus) (Lean.NameMap Lean.ReducibilityStatus) :=
  Inhabited.default.{1} (Lean.PersistentEnvExtension (Prod.{0, 0} Lean.Name Lean.ReducibilityStatus) (Prod.{0, 0} Lean.Name Lean.ReducibilityStatus) (Lean.NameMap Lean.ReducibilityStatus)) (Lean.instInhabitedPersistentEnvExtension (Prod.{0, 0} Lean.Name Lean.ReducibilityStatus) (Prod.{0, 0} Lean.Name Lean.ReducibilityStatus) (Lean.NameMap Lean.ReducibilityStatus) (Lean.NameMap.instInhabited Lean.ReducibilityStatus))
