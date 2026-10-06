import Mathlib

-- spec: recursor RoutingStrategy.rec : forall {motive : RoutingStrategy -> Sort.{u}}, (motive RoutingStrategy.drop) -> (motive RoutingStrategy.hostAccumulate) -> (motive RoutingStrategy.priorityGPU) -> (forall (t : RoutingStrategy), motive t)
