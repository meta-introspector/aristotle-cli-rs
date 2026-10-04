import Mathlib

set_option pp.all true
-- spec: Expr.QuotedCode.elim : forall {motive : Expr -> Sort.{u}} (t : Expr), (Eq.{1} Nat (Expr.ctorIdx t) 4) -> (forall (a._@._internal._hyg.0 : Expr), motive (Expr.QuotedCode a._@._internal._hyg.0)) -> (motive t)
def Expr.QuotedCode.elim : forall {motive : Expr -> Sort.{u}} (t : Expr), (Eq.{1} Nat (Expr.ctorIdx t) 4) -> (forall (a._@._internal._hyg.0 : Expr), motive (Expr.QuotedCode a._@._internal._hyg.0)) -> (motive t) :=
  fun {motive : Expr -> Sort.{u}} (t : Expr) (h : Eq.{1} Nat (Expr.ctorIdx t) 4) (QuotedCode : forall (a._@._internal._hyg.0 : Expr), motive (Expr.QuotedCode a._@._internal._hyg.0)) => Expr.ctorElim.{u} motive 4 t (Eq.symm.{1} Nat (Expr.ctorIdx t) 4 h) (PULift.up.{u, u} (forall (a._@._internal._hyg.0 : Expr), motive (Expr.QuotedCode a._@._internal._hyg.0)) QuotedCode)
