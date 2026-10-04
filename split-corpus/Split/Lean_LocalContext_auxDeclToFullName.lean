import Mathlib

set_option pp.all true
-- spec: Lean.LocalContext.auxDeclToFullName : Lean.LocalContext -> (Lean.FVarIdMap Lean.Name)
def Lean.LocalContext.auxDeclToFullName : Lean.LocalContext -> (Lean.FVarIdMap Lean.Name) :=
  fun (self : Lean.LocalContext) => self.3
