import Mathlib

set_option pp.all true
-- spec: RoutingStrategy.hostAccumulate.elim : forall {motive : RoutingStrategy -> Sort.{u}} (t : RoutingStrategy), (Eq.{1} Nat (RoutingStrategy.ctorIdx t) 1) -> (motive RoutingStrategy.hostAccumulate) -> (motive t)
def RoutingStrategy.hostAccumulate.elim : forall {motive : RoutingStrategy -> Sort.{u}} (t : RoutingStrategy), (Eq.{1} Nat (RoutingStrategy.ctorIdx t) 1) -> (motive RoutingStrategy.hostAccumulate) -> (motive t) :=
  fun {motive : RoutingStrategy -> Sort.{u}} (t : RoutingStrategy) (h : Eq.{1} Nat (RoutingStrategy.ctorIdx t) 1) (hostAccumulate : motive RoutingStrategy.hostAccumulate) => RoutingStrategy.ctorElim.{u} motive 1 t (Eq.symm.{1} Nat (RoutingStrategy.ctorIdx t) 1 h) (PULift.up.{u, u} (motive RoutingStrategy.hostAccumulate) hostAccumulate)
