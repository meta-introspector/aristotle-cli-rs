import Mathlib

set_option pp.all true
-- spec: Lean.ToExpr.toTypeExpr : forall (α : Type.{u}) [self : Lean.ToExpr.{u} α], Lean.Expr
def Lean.ToExpr.toTypeExpr : forall (α : Type.{u}) [self : Lean.ToExpr.{u} α], Lean.Expr :=
  fun (α : Type.{u}) [self : Lean.ToExpr.{u} α] => self.2
