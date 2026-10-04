import Mathlib

set_option pp.all true
-- spec: Lean.Meta.getFVarLocalDecl : Lean.Expr -> (Lean.Meta.MetaM Lean.LocalDecl)
def Lean.Meta.getFVarLocalDecl : Lean.Expr -> (Lean.Meta.MetaM Lean.LocalDecl) :=
  fun (fvar : Lean.Expr) => Lean.FVarId.getDecl (Lean.Expr.fvarId! fvar)
