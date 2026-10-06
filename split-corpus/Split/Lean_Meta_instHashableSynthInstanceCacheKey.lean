import Mathlib

set_option pp.all true
-- spec: Lean.Meta.instHashableSynthInstanceCacheKey : Hashable.{1} Lean.Meta.SynthInstanceCacheKey
def Lean.Meta.instHashableSynthInstanceCacheKey : Hashable.{1} Lean.Meta.SynthInstanceCacheKey :=
  Hashable.mk.{1} Lean.Meta.SynthInstanceCacheKey Lean.Meta.instHashableSynthInstanceCacheKey.hash
