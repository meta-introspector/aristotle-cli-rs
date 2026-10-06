import Mathlib

set_option pp.all true
-- spec: stratifyTriple : DA51Triple -> RoutingStrategy
def stratifyTriple : DA51Triple -> RoutingStrategy :=
  fun (triple : DA51Triple) => stratifyTriple.match_1.{1} (fun (x._@.RequestProject.DA51.3673591094._hygCtx._hyg.8 : Option.{0} Eigenspace) (x._@.RequestProject.DA51.3673591094._hygCtx._hyg.10 : Option.{0} Eigenspace) => RoutingStrategy) (DA51Address.toEigenspace? (DA51Triple.source triple)) (DA51Address.toEigenspace? (DA51Triple.target triple)) (fun (x._@.RequestProject.DA51.3673591094._hygCtx._hyg.19 : Option.{0} Eigenspace) => RoutingStrategy.priorityGPU) (fun (x._@.RequestProject.DA51.3673591094._hygCtx._hyg.29 : Option.{0} Eigenspace) => RoutingStrategy.priorityGPU) (fun (x._@.RequestProject.DA51.3673591094._hygCtx._hyg.39 : Option.{0} Eigenspace) => RoutingStrategy.hostAccumulate) (fun (x._@.RequestProject.DA51.3673591094._hygCtx._hyg.49 : Option.{0} Eigenspace) => RoutingStrategy.hostAccumulate) (fun (_ : Unit) => RoutingStrategy.drop) (fun (x._@.RequestProject.DA51.3673591094._hygCtx._hyg.69 : Option.{0} Eigenspace) (x._@.RequestProject.DA51.3673591094._hygCtx._hyg.68 : Option.{0} Eigenspace) => RoutingStrategy.priorityGPU)
