import Mathlib

-- spec: theorem Something.SomeResource.sizeOf_spec : forall (res : String), Eq.{1} Nat (SizeOf.sizeOf.{1} Something Something._sizeOf_inst (Something.SomeResource res)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} String String._sizeOf_inst res))
theorem Something.SomeResource.sizeOf_spec : forall (res : String), Eq.{1} Nat (SizeOf.sizeOf.{1} Something Something._sizeOf_inst (Something.SomeResource res)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} String String._sizeOf_inst res)) :=
  fun (res : String) => Eq.refl.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} String String._sizeOf_inst res))
