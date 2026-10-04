import Mathlib

-- spec: theorem Something.VertextAlgebra.sizeOf_spec : Eq.{1} Nat (SizeOf.sizeOf.{1} Something Something._sizeOf_inst Something.VertextAlgebra) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
theorem Something.VertextAlgebra.sizeOf_spec : Eq.{1} Nat (SizeOf.sizeOf.{1} Something Something._sizeOf_inst Something.VertextAlgebra) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) :=
  Eq.refl.{1} Nat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
