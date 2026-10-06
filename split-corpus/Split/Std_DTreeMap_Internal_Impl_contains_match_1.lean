import Mathlib

set_option pp.all true
-- spec: Std.DTreeMap.Internal.Impl.contains.match_1 : forall (motive : Ordering -> Sort.{u_1}) (x._@.Std.Data.DTreeMap.Internal.Queries.2396568098._hygCtx._hyg.53 : Ordering), (Unit -> (motive Ordering.lt)) -> (Unit -> (motive Ordering.gt)) -> (Unit -> (motive Ordering.eq)) -> (motive x._@.Std.Data.DTreeMap.Internal.Queries.2396568098._hygCtx._hyg.53)
def Std.DTreeMap.Internal.Impl.contains.match_1 : forall (motive : Ordering -> Sort.{u_1}) (x._@.Std.Data.DTreeMap.Internal.Queries.2396568098._hygCtx._hyg.53 : Ordering), (Unit -> (motive Ordering.lt)) -> (Unit -> (motive Ordering.gt)) -> (Unit -> (motive Ordering.eq)) -> (motive x._@.Std.Data.DTreeMap.Internal.Queries.2396568098._hygCtx._hyg.53) :=
  fun (motive : Ordering -> Sort.{u_1}) (x._@.Std.Data.DTreeMap.Internal.Queries.2396568098._hygCtx._hyg.53 : Ordering) (h_1 : Unit -> (motive Ordering.lt)) (h_2 : Unit -> (motive Ordering.gt)) (h_3 : Unit -> (motive Ordering.eq)) => Ordering.casesOn.{u_1} (fun (x : Ordering) => motive x) x._@.Std.Data.DTreeMap.Internal.Queries.2396568098._hygCtx._hyg.53 (h_1 Unit.unit) (h_3 Unit.unit) (h_2 Unit.unit)
