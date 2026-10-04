import Mathlib

set_option pp.all true
-- spec: Lean.Meta.instHashableExprConfigCacheKey : Hashable.{1} Lean.Meta.ExprConfigCacheKey
def Lean.Meta.instHashableExprConfigCacheKey : Hashable.{1} Lean.Meta.ExprConfigCacheKey :=
  Hashable.mk.{1} Lean.Meta.ExprConfigCacheKey Lean.Meta.instHashableExprConfigCacheKey._private_1
