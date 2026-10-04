import Mathlib

set_option pp.all true
-- spec: Lean.Meta.instHashableInfoCacheKey : Hashable.{1} Lean.Meta.InfoCacheKey
def Lean.Meta.instHashableInfoCacheKey : Hashable.{1} Lean.Meta.InfoCacheKey :=
  Hashable.mk.{1} Lean.Meta.InfoCacheKey Lean.Meta.instHashableInfoCacheKey._private_1
