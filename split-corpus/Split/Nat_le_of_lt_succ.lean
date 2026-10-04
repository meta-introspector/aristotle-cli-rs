import Mathlib

-- spec: theorem Nat.le_of_lt_succ : forall {m : Nat} {n : Nat}, (LT.lt.{0} Nat instLTNat m (Nat.succ n)) -> (LE.le.{0} Nat instLENat m n)
theorem Nat.le_of_lt_succ : forall {m : Nat} {n : Nat}, (LT.lt.{0} Nat instLTNat m (Nat.succ n)) -> (LE.le.{0} Nat instLENat m n) :=
  fun {m : Nat} {n : Nat} => Nat.le_of_succ_le_succ m n
