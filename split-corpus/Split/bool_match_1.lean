import Mathlib

set_option pp.all true
-- spec: bool.match_1 : forall (motive : Bool -> Sort.{u_1}) (x._@.Init.Control.Basic.2609003964._hygCtx._hyg.26 : Bool), (Unit -> (motive Bool.true)) -> (Unit -> (motive Bool.false)) -> (motive x._@.Init.Control.Basic.2609003964._hygCtx._hyg.26)
def bool.match_1 : forall (motive : Bool -> Sort.{u_1}) (x._@.Init.Control.Basic.2609003964._hygCtx._hyg.26 : Bool), (Unit -> (motive Bool.true)) -> (Unit -> (motive Bool.false)) -> (motive x._@.Init.Control.Basic.2609003964._hygCtx._hyg.26) :=
  fun (motive : Bool -> Sort.{u_1}) (x._@.Init.Control.Basic.2609003964._hygCtx._hyg.26 : Bool) (h_1 : Unit -> (motive Bool.true)) (h_2 : Unit -> (motive Bool.false)) => Bool.casesOn.{u_1} (fun (x : Bool) => motive x) x._@.Init.Control.Basic.2609003964._hygCtx._hyg.26 (h_2 Unit.unit) (h_1 Unit.unit)
