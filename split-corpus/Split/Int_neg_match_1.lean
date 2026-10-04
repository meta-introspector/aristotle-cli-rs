import Mathlib

set_option pp.all true
-- spec: Int.neg.match_1 : forall (motive : Int -> Sort.{u_1}) (n._@.Init.Data.Int.Basic.1717405508._hygCtx._hyg.8 : Int), (forall (n : Nat), motive (Int.ofNat n)) -> (forall (n : Nat), motive (Int.negSucc n)) -> (motive n._@.Init.Data.Int.Basic.1717405508._hygCtx._hyg.8)
def Int.neg.match_1 : forall (motive : Int -> Sort.{u_1}) (n._@.Init.Data.Int.Basic.1717405508._hygCtx._hyg.8 : Int), (forall (n : Nat), motive (Int.ofNat n)) -> (forall (n : Nat), motive (Int.negSucc n)) -> (motive n._@.Init.Data.Int.Basic.1717405508._hygCtx._hyg.8) :=
  fun (motive : Int -> Sort.{u_1}) (n._@.Init.Data.Int.Basic.1717405508._hygCtx._hyg.8 : Int) (h_1 : forall (n : Nat), motive (Int.ofNat n)) (h_2 : forall (n : Nat), motive (Int.negSucc n)) => Int.casesOn.{u_1} (fun (x : Int) => motive x) n._@.Init.Data.Int.Basic.1717405508._hygCtx._hyg.8 (fun (a._@._internal.0.Init.Data.Int.Basic.1717405508._hygCtx._hyg.23 : Nat) => h_1 a._@._internal.0.Init.Data.Int.Basic.1717405508._hygCtx._hyg.23) (fun (a._@._internal.0.Init.Data.Int.Basic.1717405508._hygCtx._hyg.24 : Nat) => h_2 a._@._internal.0.Init.Data.Int.Basic.1717405508._hygCtx._hyg.24)
