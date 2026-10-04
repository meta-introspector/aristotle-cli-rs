import Mathlib

set_option pp.all true
-- spec: Lean.LocalContext.decls : Lean.LocalContext -> (Lean.PersistentArray.{0} (Option.{0} Lean.LocalDecl))
def Lean.LocalContext.decls : Lean.LocalContext -> (Lean.PersistentArray.{0} (Option.{0} Lean.LocalDecl)) :=
  fun (self : Lean.LocalContext) => self.2
