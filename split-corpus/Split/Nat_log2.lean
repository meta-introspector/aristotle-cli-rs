import Mathlib

set_option pp.all true
-- spec: Nat.log2 : ([mdata borrowed:1 Nat]) -> Nat
def Nat.log2 : ([mdata borrowed:1 Nat]) -> Nat :=
  fun (n : Nat) => Nat.rec.{1} (fun (x._@.Init.Data.Nat.Log2.4195480739._hygCtx._hyg.8 : Nat) => Nat -> Nat) (fun (x._@.Init.Data.Nat.Log2.4195480739._hygCtx._hyg.13 : Nat) => 0) (fun (x._@.Init.Data.Nat.Log2.4195480739._hygCtx._hyg.20 : Nat) (ih : Nat -> Nat) (n : Nat) => Bool.rec.{1} (fun (x._@.Init.Data.Nat.Log2.4195480739._hygCtx._hyg.32 : Bool) => Nat) 0 (Nat.succ (ih (Nat.div n 2))) (Nat.ble 2 n)) n n
