import Mathlib

-- spec: theorem Nat.lt_of_le_of_lt : forall {n : Nat} {m : Nat} {k : Nat}, (LE.le.{0} Nat instLENat n m) -> (LT.lt.{0} Nat instLTNat m k) -> (LT.lt.{0} Nat instLTNat n k)
theorem Nat.lt_of_le_of_lt : forall {n : Nat} {m : Nat} {k : Nat}, (LE.le.{0} Nat instLENat n m) -> (LT.lt.{0} Nat instLTNat m k) -> (LT.lt.{0} Nat instLTNat n k) :=
  fun {n : Nat} {m : Nat} {k : Nat} (h₁ : LE.le.{0} Nat instLENat n m) (h₂ : LT.lt.{0} Nat instLTNat m k) => Nat.le_trans (Nat.succ n) (Nat.succ m) k (Nat.succ_le_succ n m h₁) h₂
