import Mathlib

set_option pp.all true
-- spec: Lean.MetavarContext.depth : Lean.MetavarContext -> Nat
def Lean.MetavarContext.depth : Lean.MetavarContext -> Nat :=
  fun (self : Lean.MetavarContext) => self.1
