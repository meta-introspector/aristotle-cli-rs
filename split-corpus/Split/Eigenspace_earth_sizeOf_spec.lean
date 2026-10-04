import Mathlib

-- spec: theorem Eigenspace.earth.sizeOf_spec : Eq.{1} Nat (SizeOf.sizeOf.{1} Eigenspace Eigenspace._sizeOf_inst Eigenspace.earth) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
theorem Eigenspace.earth.sizeOf_spec : Eq.{1} Nat (SizeOf.sizeOf.{1} Eigenspace Eigenspace._sizeOf_inst Eigenspace.earth) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) :=
  Eq.refl.{1} Nat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
