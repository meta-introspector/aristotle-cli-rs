import Mathlib

set_option pp.all true
-- spec: Lean.Meta.ExprConfigCacheKey.expr : Lean.Meta.ExprConfigCacheKey -> Lean.Expr
def Lean.Meta.ExprConfigCacheKey.expr : Lean.Meta.ExprConfigCacheKey -> Lean.Expr :=
  fun (self : Lean.Meta.ExprConfigCacheKey) => self.1
