import Mathlib

set_option pp.all true
-- spec: RoutingStrategy.ctorElimType : forall {motive : RoutingStrategy -> Sort.{u}}, Nat -> Sort.{max 1 u}
def RoutingStrategy.ctorElimType : forall {motive : RoutingStrategy -> Sort.{u}}, Nat -> Sort.{max 1 u} :=
  fun {motive : RoutingStrategy -> Sort.{u}} (ctorIdx : Nat) => cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 0) (PULift.{u, u} (motive RoutingStrategy.drop)) (cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 1) (PULift.{u, u} (motive RoutingStrategy.hostAccumulate)) (PULift.{u, u} (motive RoutingStrategy.priorityGPU)))
