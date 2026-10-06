import Mathlib

set_option pp.all true
-- spec: Lean.Meta.SynthInstanceCache : Type
def Lean.Meta.SynthInstanceCache : Type :=
  Lean.PersistentHashMap.{0, 0} Lean.Meta.SynthInstanceCacheKey (Option.{0} Lean.Meta.AbstractMVarsResult) Lean.Meta.instBEqSynthInstanceCacheKey Lean.Meta.instHashableSynthInstanceCacheKey
