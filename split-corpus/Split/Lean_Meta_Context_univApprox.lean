import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Context.univApprox : Lean.Meta.Context -> Bool
def Lean.Meta.Context.univApprox : Lean.Meta.Context -> Bool :=
  fun (self : Lean.Meta.Context) => self.9
