import Mathlib

-- spec: theorem Duality.Symmetry.sizeOf_spec : Eq.{1} Nat (SizeOf.sizeOf.{1} Duality Duality._sizeOf_inst Duality.Symmetry) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
theorem Duality.Symmetry.sizeOf_spec : Eq.{1} Nat (SizeOf.sizeOf.{1} Duality Duality._sizeOf_inst Duality.Symmetry) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) :=
  Eq.refl.{1} Nat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
