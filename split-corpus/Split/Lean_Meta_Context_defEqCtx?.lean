import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Context.defEqCtx? : Lean.Meta.Context -> (Option.{0} Lean.Meta.DefEqContext)
def Lean.Meta.Context.defEqCtx? : Lean.Meta.Context -> (Option.{0} Lean.Meta.DefEqContext) :=
  fun (self : Lean.Meta.Context) => self.6
