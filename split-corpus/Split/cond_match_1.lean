import Mathlib

set_option pp.all true
-- spec: cond.match_1 : forall (motive : Bool -> Sort.{u_1}) (c._@.Init.Prelude.3301329888._hygCtx._hyg.10 : Bool), (Unit -> (motive Bool.true)) -> (Unit -> (motive Bool.false)) -> (motive c._@.Init.Prelude.3301329888._hygCtx._hyg.10)
def cond.match_1 : forall (motive : Bool -> Sort.{u_1}) (c._@.Init.Prelude.3301329888._hygCtx._hyg.10 : Bool), (Unit -> (motive Bool.true)) -> (Unit -> (motive Bool.false)) -> (motive c._@.Init.Prelude.3301329888._hygCtx._hyg.10) :=
  fun (motive : Bool -> Sort.{u_1}) (c._@.Init.Prelude.3301329888._hygCtx._hyg.10 : Bool) (h_1 : Unit -> (motive Bool.true)) (h_2 : Unit -> (motive Bool.false)) => Bool.casesOn.{u_1} (fun (x : Bool) => motive x) c._@.Init.Prelude.3301329888._hygCtx._hyg.10 (h_2 Unit.unit) (h_1 Unit.unit)
