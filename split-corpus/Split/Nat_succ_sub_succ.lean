import Mathlib

-- spec: theorem Nat.succ_sub_succ : forall (n : Nat) (m : Nat), Eq.{1} Nat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (Nat.succ n) (Nat.succ m)) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n m)
theorem Nat.succ_sub_succ : forall (n : Nat) (m : Nat), Eq.{1} Nat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (Nat.succ n) (Nat.succ m)) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n m) :=
  fun (n : Nat) (m : Nat) => Nat.succ_sub_succ_eq_sub n m
