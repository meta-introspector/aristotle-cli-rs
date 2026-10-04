import Mathlib

set_option pp.all true
-- spec: Array.appendCore.loop.match_1 : forall (motive : Nat -> Sort.{u_1}) (i._@.Init.Prelude.1296259515._hygCtx._hyg.30 : Nat), (Unit -> (motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))) -> (forall (i' : Nat), motive (Nat.succ i')) -> (motive i._@.Init.Prelude.1296259515._hygCtx._hyg.30)
def Array.appendCore.loop.match_1 : forall (motive : Nat -> Sort.{u_1}) (i._@.Init.Prelude.1296259515._hygCtx._hyg.30 : Nat), (Unit -> (motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))) -> (forall (i' : Nat), motive (Nat.succ i')) -> (motive i._@.Init.Prelude.1296259515._hygCtx._hyg.30) :=
  fun (motive : Nat -> Sort.{u_1}) (i._@.Init.Prelude.1296259515._hygCtx._hyg.30 : Nat) (h_1 : Unit -> (motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))) (h_2 : forall (i' : Nat), motive (Nat.succ i')) => Nat.casesOn.{u_1} (fun (x : Nat) => motive x) i._@.Init.Prelude.1296259515._hygCtx._hyg.30 (h_1 Unit.unit) (fun (n._@.Init.Prelude.1296259515._hygCtx._hyg.55 : Nat) => h_2 n._@.Init.Prelude.1296259515._hygCtx._hyg.55)
