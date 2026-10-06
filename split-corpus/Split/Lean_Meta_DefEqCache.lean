import Mathlib

set_option pp.all true
-- spec: Lean.Meta.DefEqCache : Type
def Lean.Meta.DefEqCache : Type :=
  Lean.PersistentHashMap.{0, 0} Lean.Meta.DefEqCacheKey Bool Lean.Meta.instBEqDefEqCacheKey Lean.Meta.instHashableDefEqCacheKey
