import Mathlib

set_option pp.all true
-- spec: Lean.Expr.brecOn : forall {motive : Lean.Expr -> Sort.{u}} (t : Lean.Expr), (forall (t : Lean.Expr), (Lean.Expr.below.{u} motive t) -> (motive t)) -> (motive t)
def Lean.Expr.brecOn : forall {motive : Lean.Expr -> Sort.{u}} (t : Lean.Expr), (forall (t : Lean.Expr), (Lean.Expr.below.{u} motive t) -> (motive t)) -> (motive t) :=
  fun {motive : Lean.Expr -> Sort.{u}} (t : Lean.Expr) (F_1 : forall (t : Lean.Expr), (Lean.Expr.below.{u} motive t) -> (motive t)) => (Lean.Expr.brecOn.go.{u} motive t F_1).1
