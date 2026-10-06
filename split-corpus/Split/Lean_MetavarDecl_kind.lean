import Mathlib

set_option pp.all true
-- spec: Lean.MetavarDecl.kind : Lean.MetavarDecl -> Lean.MetavarKind
def Lean.MetavarDecl.kind : Lean.MetavarDecl -> Lean.MetavarKind :=
  fun (self : Lean.MetavarDecl) => self.6
