import Mathlib

set_option pp.all true
-- spec: Lean.LocalDeclKind.ctorIdx : Lean.LocalDeclKind -> Nat
def Lean.LocalDeclKind.ctorIdx : Lean.LocalDeclKind -> Nat :=
  fun (x : Lean.LocalDeclKind) => Lean.LocalDeclKind.casesOn.{1} (fun (x : Lean.LocalDeclKind) => Nat) x 0 1 2
