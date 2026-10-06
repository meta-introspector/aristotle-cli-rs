import Mathlib

-- spec: theorem Nat.lt_of_le_of_ne : forall {n : Nat} {m : Nat}, (LE.le.{0} Nat instLENat n m) -> (Not (Eq.{1} Nat n m)) -> (LT.lt.{0} Nat instLTNat n m)
theorem Nat.lt_of_le_of_ne : forall {n : Nat} {m : Nat}, (LE.le.{0} Nat instLENat n m) -> (Not (Eq.{1} Nat n m)) -> (LT.lt.{0} Nat instLTNat n m) :=
  fun {n : Nat} {m : Nat} (h₁ : LE.le.{0} Nat instLENat n m) (h₂ : Not (Eq.{1} Nat n m)) => _private.Init.Prelude.0.Nat.lt_of_le_of_ne.match_1_1 n m (fun (x._@.Init.Prelude.2732534281._hygCtx._hyg.25 : Or (LT.lt.{0} Nat instLTNat n m) (GE.ge.{0} Nat instLENat n m)) => LT.lt.{0} Nat instLTNat n m) (Nat.lt_or_ge n m) (fun (h₃ : LT.lt.{0} Nat instLTNat n m) => h₃) (fun (h₃ : GE.ge.{0} Nat instLENat n m) => absurd.{0} (Eq.{1} Nat n m) (LT.lt.{0} Nat instLTNat n m) (Nat.le_antisymm n m h₁ h₃) h₂)
