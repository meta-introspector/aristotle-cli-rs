import Mathlib

set_option pp.all true
-- spec: Lean.Core.Context.quotContext : Lean.Core.Context -> Lean.Name
def Lean.Core.Context.quotContext : Lean.Core.Context -> Lean.Name :=
  fun (self : Lean.Core.Context) => self.11
