import Mathlib

set_option pp.all true
-- spec: RoutingStrategy.priorityGPU.elim : forall {motive : RoutingStrategy -> Sort.{u}} (t : RoutingStrategy), (Eq.{1} Nat (RoutingStrategy.ctorIdx t) 2) -> (motive RoutingStrategy.priorityGPU) -> (motive t)
def RoutingStrategy.priorityGPU.elim : forall {motive : RoutingStrategy -> Sort.{u}} (t : RoutingStrategy), (Eq.{1} Nat (RoutingStrategy.ctorIdx t) 2) -> (motive RoutingStrategy.priorityGPU) -> (motive t) :=
  fun {motive : RoutingStrategy -> Sort.{u}} (t : RoutingStrategy) (h : Eq.{1} Nat (RoutingStrategy.ctorIdx t) 2) (priorityGPU : motive RoutingStrategy.priorityGPU) => RoutingStrategy.ctorElim.{u} motive 2 t (Eq.symm.{1} Nat (RoutingStrategy.ctorIdx t) 2 h) (PULift.up.{u, u} (motive RoutingStrategy.priorityGPU) priorityGPU)
