import Mathlib

set_option pp.all true
-- spec: Lean.Meta.WhnfCache : Type
def Lean.Meta.WhnfCache : Type :=
  Lean.PersistentHashMap.{0, 0} Lean.Meta.ExprConfigCacheKey Lean.Expr Lean.Meta.instBEqExprConfigCacheKey Lean.Meta.instHashableExprConfigCacheKey
