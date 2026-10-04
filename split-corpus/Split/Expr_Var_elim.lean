import Mathlib

set_option pp.all true
-- spec: Expr.Var.elim : forall {motive : Expr -> Sort.{u}} (t : Expr), (Eq.{1} Nat (Expr.ctorIdx t) 0) -> (forall (a._@._internal._hyg.0 : String), motive (Expr.Var a._@._internal._hyg.0)) -> (motive t)
def Expr.Var.elim : forall {motive : Expr -> Sort.{u}} (t : Expr), (Eq.{1} Nat (Expr.ctorIdx t) 0) -> (forall (a._@._internal._hyg.0 : String), motive (Expr.Var a._@._internal._hyg.0)) -> (motive t) :=
  fun {motive : Expr -> Sort.{u}} (t : Expr) (h : Eq.{1} Nat (Expr.ctorIdx t) 0) (Var : forall (a._@._internal._hyg.0 : String), motive (Expr.Var a._@._internal._hyg.0)) => Expr.ctorElim.{u} motive 0 t (Eq.symm.{1} Nat (Expr.ctorIdx t) 0 h) (PULift.up.{u, u} (forall (a._@._internal._hyg.0 : String), motive (Expr.Var a._@._internal._hyg.0)) Var)
