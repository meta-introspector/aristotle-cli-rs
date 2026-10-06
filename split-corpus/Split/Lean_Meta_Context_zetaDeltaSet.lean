import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Context.zetaDeltaSet : Lean.Meta.Context -> Lean.FVarIdSet
def Lean.Meta.Context.zetaDeltaSet : Lean.Meta.Context -> Lean.FVarIdSet :=
  fun (self : Lean.Meta.Context) => self.3
