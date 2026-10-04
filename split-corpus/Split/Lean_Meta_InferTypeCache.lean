import Mathlib

set_option pp.all true
-- spec: Lean.Meta.InferTypeCache : Type
def Lean.Meta.InferTypeCache : Type :=
  Lean.PersistentHashMap.{0, 0} Lean.Meta.ExprConfigCacheKey Lean.Expr Lean.Meta.instBEqExprConfigCacheKey Lean.Meta.instHashableExprConfigCacheKey
