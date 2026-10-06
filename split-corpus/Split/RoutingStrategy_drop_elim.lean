import Mathlib

set_option pp.all true
-- spec: RoutingStrategy.drop.elim : forall {motive : RoutingStrategy -> Sort.{u}} (t : RoutingStrategy), (Eq.{1} Nat (RoutingStrategy.ctorIdx t) 0) -> (motive RoutingStrategy.drop) -> (motive t)
def RoutingStrategy.drop.elim : forall {motive : RoutingStrategy -> Sort.{u}} (t : RoutingStrategy), (Eq.{1} Nat (RoutingStrategy.ctorIdx t) 0) -> (motive RoutingStrategy.drop) -> (motive t) :=
  fun {motive : RoutingStrategy -> Sort.{u}} (t : RoutingStrategy) (h : Eq.{1} Nat (RoutingStrategy.ctorIdx t) 0) (drop : motive RoutingStrategy.drop) => RoutingStrategy.ctorElim.{u} motive 0 t (Eq.symm.{1} Nat (RoutingStrategy.ctorIdx t) 0 h) (PULift.up.{u, u} (motive RoutingStrategy.drop) drop)
