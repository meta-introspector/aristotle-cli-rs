import Mathlib

-- spec: theorem MicroLean.OwnershipMode.owned.sizeOf_spec : Eq.{1} Nat (SizeOf.sizeOf.{1} MicroLean.OwnershipMode MicroLean.OwnershipMode._sizeOf_inst MicroLean.OwnershipMode.owned) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
theorem MicroLean.OwnershipMode.owned.sizeOf_spec : Eq.{1} Nat (SizeOf.sizeOf.{1} MicroLean.OwnershipMode MicroLean.OwnershipMode._sizeOf_inst MicroLean.OwnershipMode.owned) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) :=
  Eq.refl.{1} Nat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
