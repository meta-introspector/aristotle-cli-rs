import Mathlib

set_option pp.all true
-- spec: Expr.SelfRef.elim : forall {motive : Expr -> Sort.{u}} (t : Expr), (Eq.{1} Nat (Expr.ctorIdx t) 5) -> (motive Expr.SelfRef) -> (motive t)
def Expr.SelfRef.elim : forall {motive : Expr -> Sort.{u}} (t : Expr), (Eq.{1} Nat (Expr.ctorIdx t) 5) -> (motive Expr.SelfRef) -> (motive t) :=
  fun {motive : Expr -> Sort.{u}} (t : Expr) (h : Eq.{1} Nat (Expr.ctorIdx t) 5) (SelfRef : motive Expr.SelfRef) => Expr.ctorElim.{u} motive 5 t (Eq.symm.{1} Nat (Expr.ctorIdx t) 5 h) (PULift.up.{u, u} (motive Expr.SelfRef) SelfRef)
