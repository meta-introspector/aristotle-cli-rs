import Mathlib

-- spec: theorem Nat.one_add : forall (n : Nat), Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) n) (Nat.succ n)
theorem Nat.one_add : forall (n : Nat), Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) n) (Nat.succ n) :=
  fun (n : Nat) => Nat.add_comm (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) n
