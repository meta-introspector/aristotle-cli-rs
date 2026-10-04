import Mathlib

-- spec: theorem MicroLean.MutMode.owned.sizeOf_spec : Eq.{1} Nat (SizeOf.sizeOf.{1} MicroLean.MutMode MicroLean.MutMode._sizeOf_inst MicroLean.MutMode.owned) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
theorem MicroLean.MutMode.owned.sizeOf_spec : Eq.{1} Nat (SizeOf.sizeOf.{1} MicroLean.MutMode MicroLean.MutMode._sizeOf_inst MicroLean.MutMode.owned) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) :=
  Eq.refl.{1} Nat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
