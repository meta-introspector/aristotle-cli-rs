import Mathlib

-- spec: theorem Nat.not_le_of_not_ble_eq_true : forall {n : [mdata borrowed:1 Nat]} {m : [mdata borrowed:1 Nat]}, (Not (Eq.{1} Bool (Nat.ble n m) Bool.true)) -> (Not (LE.le.{0} ([mdata borrowed:1 Nat]) instLENat n m))
theorem Nat.not_le_of_not_ble_eq_true : forall {n : [mdata borrowed:1 Nat]} {m : [mdata borrowed:1 Nat]}, (Not (Eq.{1} Bool (Nat.ble n m) Bool.true)) -> (Not (LE.le.{0} ([mdata borrowed:1 Nat]) instLENat n m)) :=
  fun {n : Nat} {m : Nat} (h : Not (Eq.{1} Bool (Nat.ble n m) Bool.true)) (h' : LE.le.{0} ([mdata borrowed:1 Nat]) instLENat n m) => absurd.{0} (Eq.{1} Bool (Nat.ble n m) Bool.true) False (Nat.ble_eq_true_of_le n m h') h
