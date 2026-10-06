import Mathlib

set_option pp.all true
-- spec: Nat.Linear.Poly.cancelAux.match_3 : forall (motive : Nat -> Sort.{u_1}) (fuel._@.Init.Data.Nat.Linear.1986903903._hygCtx._hyg.15 : Nat), (Unit -> (motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))) -> (forall (fuel : Nat), motive (Nat.succ fuel)) -> (motive fuel._@.Init.Data.Nat.Linear.1986903903._hygCtx._hyg.15)
def Nat.Linear.Poly.cancelAux.match_3 : forall (motive : Nat -> Sort.{u_1}) (fuel._@.Init.Data.Nat.Linear.1986903903._hygCtx._hyg.15 : Nat), (Unit -> (motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))) -> (forall (fuel : Nat), motive (Nat.succ fuel)) -> (motive fuel._@.Init.Data.Nat.Linear.1986903903._hygCtx._hyg.15) :=
  fun (motive : Nat -> Sort.{u_1}) (fuel._@.Init.Data.Nat.Linear.1986903903._hygCtx._hyg.15 : Nat) (h_1 : Unit -> (motive (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))) (h_2 : forall (fuel : Nat), motive (Nat.succ fuel)) => Nat.casesOn.{u_1} (fun (x : Nat) => motive x) fuel._@.Init.Data.Nat.Linear.1986903903._hygCtx._hyg.15 (h_1 Unit.unit) (fun (n._@.Init.Data.Nat.Linear.1986903903._hygCtx._hyg.239 : Nat) => h_2 n._@.Init.Data.Nat.Linear.1986903903._hygCtx._hyg.239)
