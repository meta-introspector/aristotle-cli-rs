import Mathlib

set_option pp.all true
-- spec: Lean.Core.Context.ref : Lean.Core.Context -> Lean.Syntax
def Lean.Core.Context.ref : Lean.Core.Context -> Lean.Syntax :=
  fun (self : Lean.Core.Context) => self.6
