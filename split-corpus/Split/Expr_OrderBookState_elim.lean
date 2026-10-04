import Mathlib

set_option pp.all true
-- spec: Expr.OrderBookState.elim : forall {motive : Expr -> Sort.{u}} (t : Expr), (Eq.{1} Nat (Expr.ctorIdx t) 3) -> (forall (a._@._internal._hyg.0 : List.{0} (Prod.{0, 0} String Nat)), motive (Expr.OrderBookState a._@._internal._hyg.0)) -> (motive t)
def Expr.OrderBookState.elim : forall {motive : Expr -> Sort.{u}} (t : Expr), (Eq.{1} Nat (Expr.ctorIdx t) 3) -> (forall (a._@._internal._hyg.0 : List.{0} (Prod.{0, 0} String Nat)), motive (Expr.OrderBookState a._@._internal._hyg.0)) -> (motive t) :=
  fun {motive : Expr -> Sort.{u}} (t : Expr) (h : Eq.{1} Nat (Expr.ctorIdx t) 3) (OrderBookState : forall (a._@._internal._hyg.0 : List.{0} (Prod.{0, 0} String Nat)), motive (Expr.OrderBookState a._@._internal._hyg.0)) => Expr.ctorElim.{u} motive 3 t (Eq.symm.{1} Nat (Expr.ctorIdx t) 3 h) (PULift.up.{u, u} (forall (a._@._internal._hyg.0 : List.{0} (Prod.{0, 0} String Nat)), motive (Expr.OrderBookState a._@._internal._hyg.0)) OrderBookState)
