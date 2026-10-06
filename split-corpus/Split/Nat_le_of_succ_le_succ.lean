import Mathlib

-- spec: theorem Nat.le_of_succ_le_succ : forall {n : Nat} {m : Nat}, (LE.le.{0} Nat instLENat (Nat.succ n) (Nat.succ m)) -> (LE.le.{0} Nat instLENat n m)
theorem Nat.le_of_succ_le_succ : forall {n : Nat} {m : Nat}, (LE.le.{0} Nat instLENat (Nat.succ n) (Nat.succ m)) -> (LE.le.{0} Nat instLENat n m) :=
  fun {n : Nat} {m : Nat} => Nat.pred_le_pred (Nat.succ n) (Nat.succ m)
