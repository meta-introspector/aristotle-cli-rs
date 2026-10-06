import Mathlib

-- spec: theorem Something.SomeUrl.sizeOf_spec : forall (url : String), Eq.{1} Nat (SizeOf.sizeOf.{1} Something Something._sizeOf_inst (Something.SomeUrl url)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} String String._sizeOf_inst url))
theorem Something.SomeUrl.sizeOf_spec : forall (url : String), Eq.{1} Nat (SizeOf.sizeOf.{1} Something Something._sizeOf_inst (Something.SomeUrl url)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} String String._sizeOf_inst url)) :=
  fun (url : String) => Eq.refl.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} String String._sizeOf_inst url))
