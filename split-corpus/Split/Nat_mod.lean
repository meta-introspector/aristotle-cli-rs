import Mathlib

set_option pp.all true
-- spec: Nat.mod : ([mdata borrowed:1 Nat]) -> ([mdata borrowed:1 Nat]) -> Nat
def Nat.mod : ([mdata borrowed:1 Nat]) -> ([mdata borrowed:1 Nat]) -> Nat :=
  fun (x._@.Init.Prelude.342371235._hygCtx._hyg.9 : Nat) (x._@.Init.Prelude.342371235._hygCtx._hyg.10 : Nat) => Nat.mod.match_1.{1} (fun (x._@.Init.Prelude.342371235._hygCtx.9.Init.Prelude.342371235._hygCtx._hyg.28 : Nat) (x._@.Init.Prelude.342371235._hygCtx.10.Init.Prelude.342371235._hygCtx._hyg.31 : Nat) => Nat) x._@.Init.Prelude.342371235._hygCtx._hyg.9 x._@.Init.Prelude.342371235._hygCtx._hyg.10 (fun (x._@.Init.Prelude.342371235._hygCtx._hyg.38 : Nat) => OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (fun (n : Nat) (n._@.Init.Prelude.342371235._hygCtx._hyg.53 : Nat) (h._@.Init.Prelude.342371235._hygCtx._hyg.42 : Eq.{1} Nat n (Nat.succ n._@.Init.Prelude.342371235._hygCtx._hyg.53)) (m : Nat) => ite.{1} Nat (LE.le.{0} Nat instLENat m n) (Nat.decLe m n) (Nat.modCore n m) n)
