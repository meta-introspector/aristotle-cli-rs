import Mathlib

set_option pp.all true
-- spec: Lean.Meta.FunInfoCache : Type
def Lean.Meta.FunInfoCache : Type :=
  Lean.PersistentHashMap.{0, 0} Lean.Meta.InfoCacheKey Lean.Meta.FunInfo Lean.Meta.instBEqInfoCacheKey Lean.Meta.instHashableInfoCacheKey
