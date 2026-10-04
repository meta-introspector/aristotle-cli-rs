import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Cache.synthInstance : Lean.Meta.Cache -> Lean.Meta.SynthInstanceCache
def Lean.Meta.Cache.synthInstance : Lean.Meta.Cache -> Lean.Meta.SynthInstanceCache :=
  fun (self : Lean.Meta.Cache) => self.3
