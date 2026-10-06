import Mathlib

set_option pp.all true
-- spec: RoutingStrategy.ofNat : Nat -> RoutingStrategy
def RoutingStrategy.ofNat : Nat -> RoutingStrategy :=
  fun (n : Nat) => cond.{1} RoutingStrategy (Nat.ble n 0) RoutingStrategy.drop (cond.{1} RoutingStrategy (Nat.ble n 1) RoutingStrategy.hostAccumulate RoutingStrategy.priorityGPU)
