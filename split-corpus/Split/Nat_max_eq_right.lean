import Mathlib

-- spec: theorem Nat.max_eq_right : forall {a : Nat} {b : Nat}, (LE.le.{0} Nat instLENat a b) -> (Eq.{1} Nat (Max.max.{0} Nat Nat.instMax a b) b)
theorem Nat.max_eq_right : forall {a : Nat} {b : Nat}, (LE.le.{0} Nat instLENat a b) -> (Eq.{1} Nat (Max.max.{0} Nat Nat.instMax a b) b) :=
  fun {a : Nat} {b : Nat} (h : LE.le.{0} Nat instLENat a b) => if_pos.{1} (LE.le.{0} Nat instLENat a b) (Nat.decLe a b) h Nat b a
