import Mathlib

-- spec: theorem Nat.pred_succ : forall (n : Nat), Eq.{1} Nat (Nat.pred (Nat.succ n)) n
theorem Nat.pred_succ : forall (n : Nat), Eq.{1} Nat (Nat.pred (Nat.succ n)) n :=
  fun (n : Nat) => rfl.{1} Nat (Nat.pred (Nat.succ n))
