import Mathlib

set_option pp.all true
-- spec: Nat.decLe : forall (n : [mdata borrowed:1 Nat]) (m : [mdata borrowed:1 Nat]), Decidable (LE.le.{0} ([mdata borrowed:1 Nat]) instLENat n m)
def Nat.decLe : forall (n : [mdata borrowed:1 Nat]) (m : [mdata borrowed:1 Nat]), Decidable (LE.le.{0} ([mdata borrowed:1 Nat]) instLENat n m) :=
  fun (n : Nat) (m : Nat) => dite.{1} (Decidable (LE.le.{0} ([mdata borrowed:1 Nat]) instLENat n m)) (Eq.{1} Bool (Nat.ble n m) Bool.true) (instDecidableEqBool (Nat.ble n m) Bool.true) (fun (h : Eq.{1} Bool (Nat.ble n m) Bool.true) => Decidable.isTrue (LE.le.{0} ([mdata borrowed:1 Nat]) instLENat n m) (Nat.le_of_ble_eq_true n m h)) (fun (h : Not (Eq.{1} Bool (Nat.ble n m) Bool.true)) => Decidable.isFalse (LE.le.{0} ([mdata borrowed:1 Nat]) instLENat n m) (Nat.not_le_of_not_ble_eq_true n m h))
