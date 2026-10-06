import Mathlib

set_option pp.all true
-- spec: Lean.Meta.instBEqDefEqCacheKey : BEq.{0} Lean.Meta.DefEqCacheKey
def Lean.Meta.instBEqDefEqCacheKey : BEq.{0} Lean.Meta.DefEqCacheKey :=
  BEq.mk.{0} Lean.Meta.DefEqCacheKey Lean.Meta.instBEqDefEqCacheKey.beq
