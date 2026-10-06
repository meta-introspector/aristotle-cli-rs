import Mathlib

set_option pp.all true
-- spec: Lean.Meta.instBEqExprConfigCacheKey : BEq.{0} Lean.Meta.ExprConfigCacheKey
def Lean.Meta.instBEqExprConfigCacheKey : BEq.{0} Lean.Meta.ExprConfigCacheKey :=
  BEq.mk.{0} Lean.Meta.ExprConfigCacheKey (fun (a : Lean.Meta.ExprConfigCacheKey) (b : Lean.Meta.ExprConfigCacheKey) => Bool.and (Lean.Expr.equal (Lean.Meta.ExprConfigCacheKey.expr a) (Lean.Meta.ExprConfigCacheKey.expr b)) (BEq.beq.{0} UInt64 (instBEqOfDecidableEq.{0} UInt64 instDecidableEqUInt64) (Lean.Meta.ExprConfigCacheKey.configKey a) (Lean.Meta.ExprConfigCacheKey.configKey b)))
