import Mathlib

set_option pp.all true
-- spec: Lean.Core.Context.fileName : Lean.Core.Context -> String
def Lean.Core.Context.fileName : Lean.Core.Context -> String :=
  fun (self : Lean.Core.Context) => self.1
