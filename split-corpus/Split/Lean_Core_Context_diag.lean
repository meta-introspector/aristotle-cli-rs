import Mathlib

set_option pp.all true
-- spec: Lean.Core.Context.diag : Lean.Core.Context -> Bool
def Lean.Core.Context.diag : Lean.Core.Context -> Bool :=
  fun (self : Lean.Core.Context) => self.13
