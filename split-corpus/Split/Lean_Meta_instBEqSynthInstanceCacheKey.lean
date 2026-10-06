import Mathlib

set_option pp.all true
-- spec: Lean.Meta.instBEqSynthInstanceCacheKey : BEq.{0} Lean.Meta.SynthInstanceCacheKey
def Lean.Meta.instBEqSynthInstanceCacheKey : BEq.{0} Lean.Meta.SynthInstanceCacheKey :=
  BEq.mk.{0} Lean.Meta.SynthInstanceCacheKey Lean.Meta.instBEqSynthInstanceCacheKey.beq
