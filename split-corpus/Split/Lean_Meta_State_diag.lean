import Mathlib

set_option pp.all true
-- spec: Lean.Meta.State.diag : Lean.Meta.State -> Lean.Meta.Diagnostics
def Lean.Meta.State.diag : Lean.Meta.State -> Lean.Meta.Diagnostics :=
  fun (self : Lean.Meta.State) => self.5
