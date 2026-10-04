import Mathlib

-- spec: theorem RoutingStrategy.ofNat_ctorIdx : forall (x : RoutingStrategy), Eq.{1} RoutingStrategy (RoutingStrategy.ofNat (RoutingStrategy.ctorIdx x)) x
theorem RoutingStrategy.ofNat_ctorIdx : forall (x : RoutingStrategy), Eq.{1} RoutingStrategy (RoutingStrategy.ofNat (RoutingStrategy.ctorIdx x)) x :=
  fun (x : RoutingStrategy) => RoutingStrategy.casesOn.{0} (fun (x : RoutingStrategy) => Eq.{1} RoutingStrategy (RoutingStrategy.ofNat (RoutingStrategy.ctorIdx x)) x) x (Eq.refl.{1} RoutingStrategy RoutingStrategy.drop) (Eq.refl.{1} RoutingStrategy RoutingStrategy.hostAccumulate) (Eq.refl.{1} RoutingStrategy RoutingStrategy.priorityGPU)
