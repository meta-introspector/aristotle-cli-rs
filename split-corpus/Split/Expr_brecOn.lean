import Mathlib

set_option pp.all true
-- spec: Expr.brecOn : forall {motive : Expr -> Sort.{u}} (t : Expr), (forall (t : Expr), (Expr.below.{u} motive t) -> (motive t)) -> (motive t)
def Expr.brecOn : forall {motive : Expr -> Sort.{u}} (t : Expr), (forall (t : Expr), (Expr.below.{u} motive t) -> (motive t)) -> (motive t) :=
  fun {motive : Expr -> Sort.{u}} (t : Expr) (F_1 : forall (t : Expr), (Expr.below.{u} motive t) -> (motive t)) => (Expr.brecOn.go.{u} motive t F_1).1
