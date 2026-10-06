import Mathlib

set_option pp.all true
-- spec: Lean.Core.State.cache : Lean.Core.State -> Lean.Core.Cache
def Lean.Core.State.cache : Lean.Core.State -> Lean.Core.Cache :=
  fun (self : Lean.Core.State) => self.6
