import Mathlib

-- spec: theorem Nat.gt_of_not_le : forall {n : Nat} {m : Nat}, (Not (LE.le.{0} Nat instLENat n m)) -> (GT.gt.{0} Nat instLTNat n m)
theorem Nat.gt_of_not_le : forall {n : Nat} {m : Nat}, (Not (LE.le.{0} Nat instLENat n m)) -> (GT.gt.{0} Nat instLTNat n m) :=
  fun {n : Nat} {m : Nat} (h : Not (LE.le.{0} Nat instLENat n m)) => Or.resolve_right (LT.lt.{0} Nat instLTNat m n) (GE.ge.{0} Nat instLENat m n) (Nat.lt_or_ge m n) h
