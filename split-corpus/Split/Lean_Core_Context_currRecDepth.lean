import Mathlib

set_option pp.all true
-- spec: Lean.Core.Context.currRecDepth : Lean.Core.Context -> Nat
def Lean.Core.Context.currRecDepth : Lean.Core.Context -> Nat :=
  fun (self : Lean.Core.Context) => self.4
