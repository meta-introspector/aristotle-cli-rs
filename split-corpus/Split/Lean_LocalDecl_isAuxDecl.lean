import Mathlib

set_option pp.all true
-- spec: Lean.LocalDecl.isAuxDecl : Lean.LocalDecl -> Bool
def Lean.LocalDecl.isAuxDecl : Lean.LocalDecl -> Bool :=
  fun (d : Lean.LocalDecl) => Decidable.decide (Eq.{1} Lean.LocalDeclKind (Lean.LocalDecl.kind d) Lean.LocalDeclKind.auxDecl) (Lean.instDecidableEqLocalDeclKind (Lean.LocalDecl.kind d) Lean.LocalDeclKind.auxDecl)
