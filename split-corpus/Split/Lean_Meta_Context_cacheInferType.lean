import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Context.cacheInferType : Lean.Meta.Context -> Bool
def Lean.Meta.Context.cacheInferType : Lean.Meta.Context -> Bool :=
  fun (self : Lean.Meta.Context) => self.11
