import Mathlib

set_option pp.all true
-- spec: RoutingStrategy.noConfusionType : Sort.{v._@.RequestProject.DA51.133224393._hygCtx._hyg.5} -> RoutingStrategy -> RoutingStrategy -> Sort.{v._@.RequestProject.DA51.133224393._hygCtx._hyg.5}
def RoutingStrategy.noConfusionType : Sort.{v._@.RequestProject.DA51.133224393._hygCtx._hyg.5} -> RoutingStrategy -> RoutingStrategy -> Sort.{v._@.RequestProject.DA51.133224393._hygCtx._hyg.5} :=
  fun (P : Sort.{v._@.RequestProject.DA51.133224393._hygCtx._hyg.5}) (x : RoutingStrategy) (y : RoutingStrategy) => noConfusionTypeEnum.{1, 1, v._@.RequestProject.DA51.133224393._hygCtx._hyg.5} RoutingStrategy Nat instDecidableEqNat RoutingStrategy.ctorIdx P x y
