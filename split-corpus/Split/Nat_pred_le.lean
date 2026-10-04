import Mathlib

-- spec: theorem Nat.pred_le : forall (n : Nat), LE.le.{0} Nat instLENat (Nat.pred n) n
theorem Nat.pred_le : forall (n : Nat), LE.le.{0} Nat instLENat (Nat.pred n) n :=
  fun (x._@.Init.Prelude.2429363084._hygCtx._hyg.11 : Nat) => _private.Init.Prelude.0.Nat.pred_le.match_1_1 (fun (x._@.Init.Prelude.2429363084._hygCtx.11.Init.Prelude.2429363084._hygCtx._hyg.22 : Nat) => LE.le.{0} Nat instLENat (Nat.pred x._@.Init.Prelude.2429363084._hygCtx.11.Init.Prelude.2429363084._hygCtx._hyg.22) x._@.Init.Prelude.2429363084._hygCtx.11.Init.Prelude.2429363084._hygCtx._hyg.22) x._@.Init.Prelude.2429363084._hygCtx._hyg.11 (fun (_ : Unit) => Nat.le.refl (Nat.pred Nat.zero)) (fun (n._@.Init.Prelude.2429363084._hygCtx._hyg.33 : Nat) => Nat.le_succ (Nat.pred (Nat.succ n._@.Init.Prelude.2429363084._hygCtx._hyg.33)))
