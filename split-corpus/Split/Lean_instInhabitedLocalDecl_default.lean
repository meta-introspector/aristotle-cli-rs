import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedLocalDecl.default : Lean.LocalDecl
def Lean.instInhabitedLocalDecl.default : Lean.LocalDecl :=
  Lean.LocalDecl.cdecl (Inhabited.default.{1} Nat instInhabitedNat) (Inhabited.default.{1} Lean.FVarId Lean.instInhabitedFVarId) (Inhabited.default.{1} Lean.Name Lean.instInhabitedName) (Inhabited.default.{1} Lean.Expr Lean.instInhabitedExpr) (Inhabited.default.{1} Lean.BinderInfo Lean.instInhabitedBinderInfo) (Inhabited.default.{1} Lean.LocalDeclKind Lean.instInhabitedLocalDeclKind)
