import Mathlib

-- spec: theorem SProof.mk.sizeOf_spec : forall (steps : List.{0} SRewrite), Eq.{1} Nat (SizeOf.sizeOf.{1} SProof SProof._sizeOf_inst (SProof.mk steps)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} (List.{0} SRewrite) (List._sizeOf_inst.{0} SRewrite SRewrite._sizeOf_inst) steps))
theorem SProof.mk.sizeOf_spec : forall (steps : List.{0} SRewrite), Eq.{1} Nat (SizeOf.sizeOf.{1} SProof SProof._sizeOf_inst (SProof.mk steps)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} (List.{0} SRewrite) (List._sizeOf_inst.{0} SRewrite SRewrite._sizeOf_inst) steps)) :=
  fun (steps : List.{0} SRewrite) => Eq.refl.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} (List.{0} SRewrite) (List._sizeOf_inst.{0} SRewrite SRewrite._sizeOf_inst) steps))
