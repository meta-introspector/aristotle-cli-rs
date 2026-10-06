import Mathlib

set_option pp.all true
-- spec: RoutingStrategy.ctorIdx : RoutingStrategy -> Nat
def RoutingStrategy.ctorIdx : RoutingStrategy -> Nat :=
  fun (x : RoutingStrategy) => RoutingStrategy.casesOn.{1} (fun (x : RoutingStrategy) => Nat) x 0 1 2
