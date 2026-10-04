import Mathlib

set_option pp.all true
-- spec: Std.DTreeMap.Internal.Impl.insert.match_3 : forall (motive : Ordering -> Sort.{u_1}) (x._@.Std.Data.DTreeMap.Internal.Operations.2613969841._hygCtx._hyg.90 : Ordering), (Unit -> (motive Ordering.lt)) -> (Unit -> (motive Ordering.gt)) -> (Unit -> (motive Ordering.eq)) -> (motive x._@.Std.Data.DTreeMap.Internal.Operations.2613969841._hygCtx._hyg.90)
def Std.DTreeMap.Internal.Impl.insert.match_3 : forall (motive : Ordering -> Sort.{u_1}) (x._@.Std.Data.DTreeMap.Internal.Operations.2613969841._hygCtx._hyg.90 : Ordering), (Unit -> (motive Ordering.lt)) -> (Unit -> (motive Ordering.gt)) -> (Unit -> (motive Ordering.eq)) -> (motive x._@.Std.Data.DTreeMap.Internal.Operations.2613969841._hygCtx._hyg.90) :=
  fun (motive : Ordering -> Sort.{u_1}) (x._@.Std.Data.DTreeMap.Internal.Operations.2613969841._hygCtx._hyg.90 : Ordering) (h_1 : Unit -> (motive Ordering.lt)) (h_2 : Unit -> (motive Ordering.gt)) (h_3 : Unit -> (motive Ordering.eq)) => Ordering.casesOn.{u_1} (fun (x : Ordering) => motive x) x._@.Std.Data.DTreeMap.Internal.Operations.2613969841._hygCtx._hyg.90 (h_1 Unit.unit) (h_3 Unit.unit) (h_2 Unit.unit)
