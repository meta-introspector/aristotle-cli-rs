import Mathlib

set_option pp.all true
-- spec: Lean.LocalDeclKind.casesOn : forall {motive : Lean.LocalDeclKind -> Sort.{u}} (t : Lean.LocalDeclKind), (motive Lean.LocalDeclKind.default) -> (motive Lean.LocalDeclKind.implDetail) -> (motive Lean.LocalDeclKind.auxDecl) -> (motive t)
def Lean.LocalDeclKind.casesOn : forall {motive : Lean.LocalDeclKind -> Sort.{u}} (t : Lean.LocalDeclKind), (motive Lean.LocalDeclKind.default) -> (motive Lean.LocalDeclKind.implDetail) -> (motive Lean.LocalDeclKind.auxDecl) -> (motive t) :=
  fun {motive : Lean.LocalDeclKind -> Sort.{u}} (t : Lean.LocalDeclKind) (default : motive Lean.LocalDeclKind.default) (implDetail : motive Lean.LocalDeclKind.implDetail) (auxDecl : motive Lean.LocalDeclKind.auxDecl) => Lean.LocalDeclKind.rec.{u} motive default implDetail auxDecl t
