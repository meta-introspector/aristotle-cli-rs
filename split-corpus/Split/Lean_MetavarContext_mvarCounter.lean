import Mathlib

set_option pp.all true
-- spec: Lean.MetavarContext.mvarCounter : Lean.MetavarContext -> Nat
def Lean.MetavarContext.mvarCounter : Lean.MetavarContext -> Nat :=
  fun (self : Lean.MetavarContext) => self.3
