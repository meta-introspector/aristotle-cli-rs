import Mathlib

set_option pp.all true
-- spec: Lean.Core.InstantiateLevelCache : Type
def Lean.Core.InstantiateLevelCache : Type :=
  Lean.PersistentHashMap.{0, 0} Lean.Name (Prod.{0, 0} (List.{0} Lean.Level) Lean.Expr) Lean.Name.instBEq Lean.instHashableName
