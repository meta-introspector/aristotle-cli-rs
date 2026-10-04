import Mathlib

set_option pp.all true
-- spec: Lean.Meta.ExprConfigCacheKey.configKey : Lean.Meta.ExprConfigCacheKey -> UInt64
def Lean.Meta.ExprConfigCacheKey.configKey : Lean.Meta.ExprConfigCacheKey -> UInt64 :=
  fun (self : Lean.Meta.ExprConfigCacheKey) => self.2
