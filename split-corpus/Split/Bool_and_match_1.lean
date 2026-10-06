import Mathlib

set_option pp.all true
-- spec: Bool.and.match_1 : forall (motive : Bool -> Sort.{u_1}) (x._@.Init.Prelude.2579035302._hygCtx._hyg.8 : Bool), (Unit -> (motive Bool.false)) -> (Unit -> (motive Bool.true)) -> (motive x._@.Init.Prelude.2579035302._hygCtx._hyg.8)
def Bool.and.match_1 : forall (motive : Bool -> Sort.{u_1}) (x._@.Init.Prelude.2579035302._hygCtx._hyg.8 : Bool), (Unit -> (motive Bool.false)) -> (Unit -> (motive Bool.true)) -> (motive x._@.Init.Prelude.2579035302._hygCtx._hyg.8) :=
  fun (motive : Bool -> Sort.{u_1}) (x._@.Init.Prelude.2579035302._hygCtx._hyg.8 : Bool) (h_1 : Unit -> (motive Bool.false)) (h_2 : Unit -> (motive Bool.true)) => Bool.casesOn.{u_1} (fun (x : Bool) => motive x) x._@.Init.Prelude.2579035302._hygCtx._hyg.8 (h_1 Unit.unit) (h_2 Unit.unit)
