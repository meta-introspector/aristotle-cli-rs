import Mathlib

set_option pp.all true
-- spec: Lean.Core.State.ngen : Lean.Core.State -> Lean.NameGenerator
def Lean.Core.State.ngen : Lean.Core.State -> Lean.NameGenerator :=
  fun (self : Lean.Core.State) => self.3
