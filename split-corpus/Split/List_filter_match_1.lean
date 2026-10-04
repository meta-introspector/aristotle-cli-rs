import Mathlib

set_option pp.all true
-- spec: List.filter.match_1 : forall (motive : Bool -> Sort.{u_1}) (x._@.Init.Data.List.Basic.2342288710._hygCtx._hyg.50 : Bool), (Unit -> (motive Bool.true)) -> (Unit -> (motive Bool.false)) -> (motive x._@.Init.Data.List.Basic.2342288710._hygCtx._hyg.50)
def List.filter.match_1 : forall (motive : Bool -> Sort.{u_1}) (x._@.Init.Data.List.Basic.2342288710._hygCtx._hyg.50 : Bool), (Unit -> (motive Bool.true)) -> (Unit -> (motive Bool.false)) -> (motive x._@.Init.Data.List.Basic.2342288710._hygCtx._hyg.50) :=
  fun (motive : Bool -> Sort.{u_1}) (x._@.Init.Data.List.Basic.2342288710._hygCtx._hyg.50 : Bool) (h_1 : Unit -> (motive Bool.true)) (h_2 : Unit -> (motive Bool.false)) => Bool.casesOn.{u_1} (fun (x : Bool) => motive x) x._@.Init.Data.List.Basic.2342288710._hygCtx._hyg.50 (h_2 Unit.unit) (h_1 Unit.unit)
