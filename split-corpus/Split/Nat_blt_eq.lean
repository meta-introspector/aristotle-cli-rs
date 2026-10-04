import Mathlib

-- spec: theorem Nat.blt_eq : forall {x : Nat} {y : Nat}, Eq.{1} Prop (Eq.{1} Bool (Nat.blt x y) Bool.true) (LT.lt.{0} Nat instLTNat x y)
theorem Nat.blt_eq : forall {x : Nat} {y : Nat}, Eq.{1} Prop (Eq.{1} Bool (Nat.blt x y) Bool.true) (LT.lt.{0} Nat instLTNat x y) :=
  fun {x : Nat} {y : Nat} => propext (Eq.{1} Bool (Nat.blt x y) Bool.true) (LT.lt.{0} Nat instLTNat x y) (Iff.intro (Eq.{1} Bool (Nat.blt x y) Bool.true) (LT.lt.{0} Nat instLTNat x y) (Nat.le_of_ble_eq_true (Nat.succ x) y) (Nat.ble_eq_true_of_le (Nat.succ x) y))
