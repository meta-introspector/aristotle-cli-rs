import Mathlib

set_option pp.all true
-- spec: RoutingStrategy.noConfusion : forall {P : Sort.{v._@.RequestProject.DA51.133224393._hygCtx._hyg.6}} {x : RoutingStrategy} {y : RoutingStrategy}, (Eq.{1} RoutingStrategy x y) -> (RoutingStrategy.noConfusionType.{v._@.RequestProject.DA51.133224393._hygCtx._hyg.6} P x y)
def RoutingStrategy.noConfusion : forall {P : Sort.{v._@.RequestProject.DA51.133224393._hygCtx._hyg.6}} {x : RoutingStrategy} {y : RoutingStrategy}, (Eq.{1} RoutingStrategy x y) -> (RoutingStrategy.noConfusionType.{v._@.RequestProject.DA51.133224393._hygCtx._hyg.6} P x y) :=
  fun {P : Sort.{v._@.RequestProject.DA51.133224393._hygCtx._hyg.6}} {x : RoutingStrategy} {y : RoutingStrategy} (h : Eq.{1} RoutingStrategy x y) => noConfusionEnum.{1, 1, v._@.RequestProject.DA51.133224393._hygCtx._hyg.6} RoutingStrategy Nat instDecidableEqNat RoutingStrategy.ctorIdx P x y h
