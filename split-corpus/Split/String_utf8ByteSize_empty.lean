import Mathlib

-- spec: theorem String.utf8ByteSize_empty : Eq.{1} Nat (String.utf8ByteSize "") (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))
theorem String.utf8ByteSize_empty : Eq.{1} Nat (String.utf8ByteSize "") (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) :=
  rfl.{1} Nat (String.utf8ByteSize "")
