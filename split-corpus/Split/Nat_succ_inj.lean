import Mathlib

-- spec: theorem Nat.succ.inj : forall {m : Nat} {n : Nat}, (Eq.{1} Nat (Nat.succ m) (Nat.succ n)) -> (Eq.{1} Nat m n)
theorem Nat.succ.inj : forall {m : Nat} {n : Nat}, (Eq.{1} Nat (Nat.succ m) (Nat.succ n)) -> (Eq.{1} Nat m n) :=
  fun {m : Nat} {n : Nat} (x : Eq.{1} Nat (Nat.succ m) (Nat.succ n)) => Nat.noConfusion.{0} (Eq.{1} Nat m n) (Nat.succ m) (Nat.succ n) x (id.{0} (Eq.{1} Nat m n))
