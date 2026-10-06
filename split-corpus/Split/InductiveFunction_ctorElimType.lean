import Mathlib

set_option pp.all true
-- spec: InductiveFunction.ctorElimType : forall {motive : InductiveFunction -> Sort.{u}}, Nat -> Sort.{max 1 u}
def InductiveFunction.ctorElimType : forall {motive : InductiveFunction -> Sort.{u}}, Nat -> Sort.{max 1 u} :=
  fun {motive : InductiveFunction -> Sort.{u}} (ctorIdx : Nat) => cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 0) (PULift.{u, u} (forall (a._@._internal._hyg.0 : Expr -> InductiveFunction), motive (InductiveFunction.LLMQuerying a._@._internal._hyg.0))) (cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 1) (PULift.{u, u} (forall (a._@._internal._hyg.0 : Expr -> InductiveFunction), motive (InductiveFunction.CodeParsing a._@._internal._hyg.0))) (PULift.{u, u} (forall (a._@._internal._hyg.0 : Expr -> InductiveFunction), motive (InductiveFunction.SelfReferencing a._@._internal._hyg.0))))
