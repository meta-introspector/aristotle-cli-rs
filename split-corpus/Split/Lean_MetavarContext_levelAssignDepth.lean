import Mathlib

set_option pp.all true
-- spec: Lean.MetavarContext.levelAssignDepth : Lean.MetavarContext -> Nat
def Lean.MetavarContext.levelAssignDepth : Lean.MetavarContext -> Nat :=
  fun (self : Lean.MetavarContext) => self.2
