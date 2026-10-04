import Mathlib

-- spec: theorem Nat.lt_of_succ_lt_succ : forall {n : Nat} {m : Nat}, (LT.lt.{0} Nat instLTNat (Nat.succ n) (Nat.succ m)) -> (LT.lt.{0} Nat instLTNat n m)
theorem Nat.lt_of_succ_lt_succ : forall {n : Nat} {m : Nat}, (LT.lt.{0} Nat instLTNat (Nat.succ n) (Nat.succ m)) -> (LT.lt.{0} Nat instLTNat n m) :=
  fun {n : Nat} {m : Nat} => Nat.le_of_succ_le_succ (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) m
