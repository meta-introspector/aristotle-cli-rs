import Mathlib

set_option pp.all true
-- spec: Lean.Core.Context.options : Lean.Core.Context -> Lean.Options
def Lean.Core.Context.options : Lean.Core.Context -> Lean.Options :=
  fun (self : Lean.Core.Context) => self.3
