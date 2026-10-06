import Mathlib

-- spec: theorem Nat.sub_succ : forall (n : Nat) (m : Nat), Eq.{1} Nat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n (Nat.succ m)) (Nat.pred (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n m))
theorem Nat.sub_succ : forall (n : Nat) (m : Nat), Eq.{1} Nat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n (Nat.succ m)) (Nat.pred (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n m)) :=
  fun (n : Nat) (m : Nat) => rfl.{1} Nat (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) n (Nat.succ m))
