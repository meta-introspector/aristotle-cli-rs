import Mathlib

set_option pp.all true
-- spec: Lean.Meta.State.mctx : Lean.Meta.State -> Lean.MetavarContext
def Lean.Meta.State.mctx : Lean.Meta.State -> Lean.MetavarContext :=
  fun (self : Lean.Meta.State) => self.1
