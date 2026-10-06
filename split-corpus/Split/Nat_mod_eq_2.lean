import Mathlib

-- spec: theorem Nat.mod.eq_2 : forall (x._@.Init.Prelude.342371235._hygCtx._hyg.10 : Nat) (n : Nat), Eq.{1} Nat (Nat.mod (Nat.succ n) x._@.Init.Prelude.342371235._hygCtx._hyg.10) (ite.{1} Nat (LE.le.{0} Nat instLENat x._@.Init.Prelude.342371235._hygCtx._hyg.10 (Nat.succ n)) (Nat.decLe x._@.Init.Prelude.342371235._hygCtx._hyg.10 (Nat.succ n)) (Nat.modCore (Nat.succ n) x._@.Init.Prelude.342371235._hygCtx._hyg.10) (Nat.succ n))
theorem Nat.mod.eq_2 : forall (x._@.Init.Prelude.342371235._hygCtx._hyg.10 : Nat) (n : Nat), Eq.{1} Nat (Nat.mod (Nat.succ n) x._@.Init.Prelude.342371235._hygCtx._hyg.10) (ite.{1} Nat (LE.le.{0} Nat instLENat x._@.Init.Prelude.342371235._hygCtx._hyg.10 (Nat.succ n)) (Nat.decLe x._@.Init.Prelude.342371235._hygCtx._hyg.10 (Nat.succ n)) (Nat.modCore (Nat.succ n) x._@.Init.Prelude.342371235._hygCtx._hyg.10) (Nat.succ n)) :=
  fun (x : Nat) (n : Nat) => Eq.refl.{1} Nat (Nat.mod (Nat.succ n) x)
