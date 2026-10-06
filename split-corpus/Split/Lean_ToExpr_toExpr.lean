import Mathlib

set_option pp.all true
-- spec: Lean.ToExpr.toExpr : forall {α : Type.{u}} [self : Lean.ToExpr.{u} α], α -> Lean.Expr
def Lean.ToExpr.toExpr : forall {α : Type.{u}} [self : Lean.ToExpr.{u} α], α -> Lean.Expr :=
  fun (α : Type.{u}) [self : Lean.ToExpr.{u} α] => self.1
