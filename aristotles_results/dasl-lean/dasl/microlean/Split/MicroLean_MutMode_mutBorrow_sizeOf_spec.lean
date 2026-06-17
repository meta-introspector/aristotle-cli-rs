import Mathlib

-- spec: theorem MicroLean.MutMode.mutBorrow.sizeOf_spec : Eq.{1} Nat (SizeOf.sizeOf.{1} MicroLean.MutMode MicroLean.MutMode._sizeOf_inst MicroLean.MutMode.mutBorrow) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
theorem MicroLean.MutMode.mutBorrow.sizeOf_spec : Eq.{1} Nat (SizeOf.sizeOf.{1} MicroLean.MutMode MicroLean.MutMode._sizeOf_inst MicroLean.MutMode.mutBorrow) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) :=
  Eq.refl.{1} Nat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
