import Mathlib

set_option pp.all true
-- spec: Lean.Meta.State.cache : Lean.Meta.State -> Lean.Meta.Cache
def Lean.Meta.State.cache : Lean.Meta.State -> Lean.Meta.Cache :=
  fun (self : Lean.Meta.State) => self.2
