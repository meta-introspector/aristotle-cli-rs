import Mathlib

-- spec: theorem Nat.zero_mod : forall (b : Nat), Eq.{1} Nat (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) b) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))
theorem Nat.zero_mod : forall (b : Nat), Eq.{1} Nat (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) b) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) :=
  fun (b : Nat) => rfl.{1} Nat (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) b)
