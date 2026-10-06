import Mathlib

set_option pp.all true
-- spec: Expr.ctorElimType : forall {motive : Expr -> Sort.{u}}, Nat -> Sort.{max 1 u}
def Expr.ctorElimType : forall {motive : Expr -> Sort.{u}}, Nat -> Sort.{max 1 u} :=
  fun {motive : Expr -> Sort.{u}} (ctorIdx : Nat) => cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 2) (cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 0) (PULift.{u, u} (forall (a._@._internal._hyg.0 : String), motive (Expr.Var a._@._internal._hyg.0))) (cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 1) (PULift.{u, u} (forall (a._@._internal._hyg.0 : String), motive (Expr.LLMQuery a._@._internal._hyg.0))) (PULift.{u, u} (forall (a._@._internal._hyg.0 : String), motive (Expr.LLMResponse a._@._internal._hyg.0))))) (cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 3) (PULift.{u, u} (forall (a._@._internal._hyg.0 : List.{0} (Prod.{0, 0} String Nat)), motive (Expr.OrderBookState a._@._internal._hyg.0))) (cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 4) (PULift.{u, u} (forall (a._@._internal._hyg.0 : Expr), motive (Expr.QuotedCode a._@._internal._hyg.0))) (PULift.{u, u} (motive Expr.SelfRef))))
