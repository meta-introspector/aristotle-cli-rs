import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Context.synthPendingDepth : Lean.Meta.Context -> Nat
def Lean.Meta.Context.synthPendingDepth : Lean.Meta.Context -> Nat :=
  fun (self : Lean.Meta.Context) => self.7
