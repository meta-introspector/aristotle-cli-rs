import Mathlib

-- spec: theorem RoutingStrategy.hostAccumulate.sizeOf_spec : Eq.{1} Nat (SizeOf.sizeOf.{1} RoutingStrategy RoutingStrategy._sizeOf_inst RoutingStrategy.hostAccumulate) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
theorem RoutingStrategy.hostAccumulate.sizeOf_spec : Eq.{1} Nat (SizeOf.sizeOf.{1} RoutingStrategy RoutingStrategy._sizeOf_inst RoutingStrategy.hostAccumulate) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) :=
  Eq.refl.{1} Nat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
