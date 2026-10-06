import Mathlib

set_option pp.all true
-- spec: Lean.Meta.instBEqInfoCacheKey : BEq.{0} Lean.Meta.InfoCacheKey
def Lean.Meta.instBEqInfoCacheKey : BEq.{0} Lean.Meta.InfoCacheKey :=
  BEq.mk.{0} Lean.Meta.InfoCacheKey Lean.Meta.instBEqInfoCacheKey.beq
