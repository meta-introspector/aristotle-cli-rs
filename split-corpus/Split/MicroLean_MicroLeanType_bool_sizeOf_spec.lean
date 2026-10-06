import Mathlib

-- spec: theorem MicroLean.MicroLeanType.bool.sizeOf_spec : Eq.{1} Nat (SizeOf.sizeOf.{1} MicroLean.MicroLeanType MicroLean.MicroLeanType._sizeOf_inst MicroLean.MicroLeanType.bool) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
theorem MicroLean.MicroLeanType.bool.sizeOf_spec : Eq.{1} Nat (SizeOf.sizeOf.{1} MicroLean.MicroLeanType MicroLean.MicroLeanType._sizeOf_inst MicroLean.MicroLeanType.bool) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) :=
  Eq.refl.{1} Nat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
