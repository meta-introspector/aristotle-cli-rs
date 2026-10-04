import Mathlib

-- spec: theorem Nat.min_eq_left : forall {a : Nat} {b : Nat}, (LE.le.{0} Nat instLENat a b) -> (Eq.{1} Nat (Min.min.{0} Nat instMinNat a b) a)
theorem Nat.min_eq_left : forall {a : Nat} {b : Nat}, (LE.le.{0} Nat instLENat a b) -> (Eq.{1} Nat (Min.min.{0} Nat instMinNat a b) a) :=
  fun {a : Nat} {b : Nat} (h : LE.le.{0} Nat instLENat a b) => if_pos.{1} (LE.le.{0} Nat instLENat a b) (Nat.decLe a b) h Nat a b
