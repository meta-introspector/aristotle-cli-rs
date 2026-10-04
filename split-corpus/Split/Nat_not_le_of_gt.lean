import Mathlib

-- spec: theorem Nat.not_le_of_gt : forall {n : Nat} {m : Nat}, (GT.gt.{0} Nat instLTNat n m) -> (Not (LE.le.{0} Nat instLENat n m))
theorem Nat.not_le_of_gt : forall {n : Nat} {m : Nat}, (GT.gt.{0} Nat instLTNat n m) -> (Not (LE.le.{0} Nat instLENat n m)) :=
  fun {n : Nat} {m : Nat} (h : GT.gt.{0} Nat instLTNat n m) (h₁ : LE.le.{0} Nat instLENat n m) => _private.Init.Data.Nat.Basic.0.Nat.not_le_of_gt.match_1_1 n m (fun (x._@.Init.Data.Nat.Basic.792224983._hygCtx._hyg.29 : Or (LT.lt.{0} Nat instLTNat n m) (GE.ge.{0} Nat instLENat n m)) => False) (Nat.lt_or_ge n m) (fun (h₂ : LT.lt.{0} Nat instLTNat n m) => absurd.{0} (LT.lt.{0} Nat instLTNat m m) False (Nat.lt_trans m n m h h₂) (Nat.lt_irrefl m)) (fun (h₂ : GE.ge.{0} Nat instLENat n m) => have Heq : Eq.{1} Nat n m := Nat.le_antisymm n m h₁ h₂; absurd.{0} (LT.lt.{0} Nat instLTNat m m) False (Eq.subst.{1} Nat (LT.lt.{0} Nat instLTNat m) n m Heq h) (Nat.lt_irrefl m))
