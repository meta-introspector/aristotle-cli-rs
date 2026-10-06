import Mathlib

set_option pp.all true
-- spec: Nat.Linear.Expr.brecOn : forall {motive : Nat.Linear.Expr -> Sort.{u}} (t : Nat.Linear.Expr), (forall (t : Nat.Linear.Expr), (Nat.Linear.Expr.below.{u} motive t) -> (motive t)) -> (motive t)
def Nat.Linear.Expr.brecOn : forall {motive : Nat.Linear.Expr -> Sort.{u}} (t : Nat.Linear.Expr), (forall (t : Nat.Linear.Expr), (Nat.Linear.Expr.below.{u} motive t) -> (motive t)) -> (motive t) :=
  fun {motive : Nat.Linear.Expr -> Sort.{u}} (t : Nat.Linear.Expr) (F_1 : forall (t : Nat.Linear.Expr), (Nat.Linear.Expr.below.{u} motive t) -> (motive t)) => (Nat.Linear.Expr.brecOn.go.{u} motive t F_1).1
