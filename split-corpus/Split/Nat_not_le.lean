import Mathlib

-- spec: theorem Nat.not_le : forall {a : Nat} {b : Nat}, Iff (Not (LE.le.{0} Nat instLENat a b)) (LT.lt.{0} Nat instLTNat b a)
theorem Nat.not_le : forall {a : Nat} {b : Nat}, Iff (Not (LE.le.{0} Nat instLENat a b)) (LT.lt.{0} Nat instLTNat b a) :=
  fun {a : Nat} {b : Nat} => Iff.intro (Not (LE.le.{0} Nat instLENat a b)) (LT.lt.{0} Nat instLTNat b a) (Nat.gt_of_not_le a b) (Nat.not_le_of_gt a b)
