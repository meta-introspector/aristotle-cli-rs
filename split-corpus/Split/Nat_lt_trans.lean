import Mathlib

-- spec: theorem Nat.lt_trans : forall {n : Nat} {m : Nat} {k : Nat}, (LT.lt.{0} Nat instLTNat n m) -> (LT.lt.{0} Nat instLTNat m k) -> (LT.lt.{0} Nat instLTNat n k)
theorem Nat.lt_trans : forall {n : Nat} {m : Nat} {k : Nat}, (LT.lt.{0} Nat instLTNat n m) -> (LT.lt.{0} Nat instLTNat m k) -> (LT.lt.{0} Nat instLTNat n k) :=
  fun {n : Nat} {m : Nat} {k : Nat} (h₁ : LT.lt.{0} Nat instLTNat n m) => Nat.le_trans (Nat.succ n) (Nat.succ m) k (Nat.le_succ_of_le (Nat.succ n) m h₁)
