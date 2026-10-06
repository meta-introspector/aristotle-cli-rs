import Mathlib

set_option pp.all true
-- spec: Lean.Meta.State.zetaDeltaFVarIds : Lean.Meta.State -> Lean.FVarIdSet
def Lean.Meta.State.zetaDeltaFVarIds : Lean.Meta.State -> Lean.FVarIdSet :=
  fun (self : Lean.Meta.State) => self.3
