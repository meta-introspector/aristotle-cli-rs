import Mathlib

set_option pp.all true
-- spec: Lean.Meta.instHashableDefEqCacheKey : Hashable.{1} Lean.Meta.DefEqCacheKey
def Lean.Meta.instHashableDefEqCacheKey : Hashable.{1} Lean.Meta.DefEqCacheKey :=
  Hashable.mk.{1} Lean.Meta.DefEqCacheKey Lean.Meta.instHashableDefEqCacheKey._private_1
