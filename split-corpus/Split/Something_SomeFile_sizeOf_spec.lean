import Mathlib

-- spec: theorem Something.SomeFile.sizeOf_spec : forall (content : String), Eq.{1} Nat (SizeOf.sizeOf.{1} Something Something._sizeOf_inst (Something.SomeFile content)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} String String._sizeOf_inst content))
theorem Something.SomeFile.sizeOf_spec : forall (content : String), Eq.{1} Nat (SizeOf.sizeOf.{1} Something Something._sizeOf_inst (Something.SomeFile content)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} String String._sizeOf_inst content)) :=
  fun (content : String) => Eq.refl.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} String String._sizeOf_inst content))
