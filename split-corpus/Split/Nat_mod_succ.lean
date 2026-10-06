import Mathlib

-- spec: theorem Nat.mod_succ : forall (n : Nat), Eq.{1} Nat (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) n (Nat.succ n)) n
theorem Nat.mod_succ : forall (n : Nat), Eq.{1} Nat (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) n (Nat.succ n)) n :=
  fun (n : Nat) => Nat.mod_eq_of_lt n (Nat.succ n) (Nat.lt_succ_self n)
