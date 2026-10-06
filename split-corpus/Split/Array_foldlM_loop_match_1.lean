import Mathlib

set_option pp.all true
-- spec: Array.foldlM.loop.match_1 : forall (motive : Nat -> Sort.{u_1}) (i._@.Init.Data.Array.Basic.4078766369._hygCtx._hyg.81 : Nat), (Unit -> (motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))) -> (forall (i' : Nat), motive (Nat.succ i')) -> (motive i._@.Init.Data.Array.Basic.4078766369._hygCtx._hyg.81)
def Array.foldlM.loop.match_1 : forall (motive : Nat -> Sort.{u_1}) (i._@.Init.Data.Array.Basic.4078766369._hygCtx._hyg.81 : Nat), (Unit -> (motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))) -> (forall (i' : Nat), motive (Nat.succ i')) -> (motive i._@.Init.Data.Array.Basic.4078766369._hygCtx._hyg.81) :=
  fun (motive : Nat -> Sort.{u_1}) (i._@.Init.Data.Array.Basic.4078766369._hygCtx._hyg.81 : Nat) (h_1 : Unit -> (motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))) (h_2 : forall (i' : Nat), motive (Nat.succ i')) => Nat.casesOn.{u_1} (fun (x : Nat) => motive x) i._@.Init.Data.Array.Basic.4078766369._hygCtx._hyg.81 (h_1 Unit.unit) (fun (n._@.Init.Data.Array.Basic.4078766369._hygCtx._hyg.141 : Nat) => h_2 n._@.Init.Data.Array.Basic.4078766369._hygCtx._hyg.141)
