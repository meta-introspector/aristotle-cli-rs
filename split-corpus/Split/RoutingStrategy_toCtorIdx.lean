import Mathlib

set_option pp.all true
-- spec: RoutingStrategy.toCtorIdx : RoutingStrategy -> Nat
def RoutingStrategy.toCtorIdx : RoutingStrategy -> Nat :=
  RoutingStrategy.ctorIdx
