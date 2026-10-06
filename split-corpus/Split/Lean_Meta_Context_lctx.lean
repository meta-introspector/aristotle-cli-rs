import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Context.lctx : Lean.Meta.Context -> Lean.LocalContext
def Lean.Meta.Context.lctx : Lean.Meta.Context -> Lean.LocalContext :=
  fun (self : Lean.Meta.Context) => self.4
