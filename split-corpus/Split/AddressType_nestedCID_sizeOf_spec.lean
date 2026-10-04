import Mathlib

-- spec: theorem AddressType.nestedCID.sizeOf_spec : Eq.{1} Nat (SizeOf.sizeOf.{1} AddressType AddressType._sizeOf_inst AddressType.nestedCID) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
theorem AddressType.nestedCID.sizeOf_spec : Eq.{1} Nat (SizeOf.sizeOf.{1} AddressType AddressType._sizeOf_inst AddressType.nestedCID) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) :=
  Eq.refl.{1} Nat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
