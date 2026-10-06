import Mathlib

-- spec: theorem Nat.le_total : forall (m : Nat) (n : Nat), Or (LE.le.{0} Nat instLENat m n) (LE.le.{0} Nat instLENat n m)
theorem Nat.le_total : forall (m : Nat) (n : Nat), Or (LE.le.{0} Nat instLENat m n) (LE.le.{0} Nat instLENat n m) :=
  fun (m : Nat) (n : Nat) => _private.Init.Data.Nat.Basic.0.Nat.le_total.match_1_1 m n (fun (x._@.Init.Data.Nat.Basic.477940745._hygCtx._hyg.26 : Or (LT.lt.{0} Nat instLTNat m n) (GE.ge.{0} Nat instLENat m n)) => Or (LE.le.{0} Nat instLENat m n) (LE.le.{0} Nat instLENat n m)) (Nat.lt_or_ge m n) (fun (h : LT.lt.{0} Nat instLTNat m n) => Or.inl (LE.le.{0} Nat instLENat m n) (LE.le.{0} Nat instLENat n m) (Nat.le_of_lt m n h)) (fun (h : GE.ge.{0} Nat instLENat m n) => Or.inr (LE.le.{0} Nat instLENat m n) (LE.le.{0} Nat instLENat n m) h)
