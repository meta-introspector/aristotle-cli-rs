import Mathlib

set_option pp.all true
-- spec: RoutingStrategy.recOn : forall {motive : RoutingStrategy -> Sort.{u}} (t : RoutingStrategy), (motive RoutingStrategy.drop) -> (motive RoutingStrategy.hostAccumulate) -> (motive RoutingStrategy.priorityGPU) -> (motive t)
def RoutingStrategy.recOn : forall {motive : RoutingStrategy -> Sort.{u}} (t : RoutingStrategy), (motive RoutingStrategy.drop) -> (motive RoutingStrategy.hostAccumulate) -> (motive RoutingStrategy.priorityGPU) -> (motive t) :=
  fun {motive : RoutingStrategy -> Sort.{u}} (t : RoutingStrategy) (drop : motive RoutingStrategy.drop) (hostAccumulate : motive RoutingStrategy.hostAccumulate) (priorityGPU : motive RoutingStrategy.priorityGPU) => RoutingStrategy.rec.{u} motive drop hostAccumulate priorityGPU t
