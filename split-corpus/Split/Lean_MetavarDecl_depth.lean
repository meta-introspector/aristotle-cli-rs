import Mathlib

set_option pp.all true
-- spec: Lean.MetavarDecl.depth : Lean.MetavarDecl -> Nat
def Lean.MetavarDecl.depth : Lean.MetavarDecl -> Nat :=
  fun (self : Lean.MetavarDecl) => self.4
