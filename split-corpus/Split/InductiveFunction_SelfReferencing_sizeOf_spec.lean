import Mathlib

-- spec: theorem InductiveFunction.SelfReferencing.sizeOf_spec : forall (a._@._internal._hyg.0 : Expr -> InductiveFunction), Eq.{1} Nat (SizeOf.sizeOf.{1} InductiveFunction InductiveFunction._sizeOf_inst (InductiveFunction.SelfReferencing a._@._internal._hyg.0)) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
theorem InductiveFunction.SelfReferencing.sizeOf_spec : forall (a._@._internal._hyg.0 : Expr -> InductiveFunction), Eq.{1} Nat (SizeOf.sizeOf.{1} InductiveFunction InductiveFunction._sizeOf_inst (InductiveFunction.SelfReferencing a._@._internal._hyg.0)) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) :=
  fun (a._@._internal._hyg.0 : Expr -> InductiveFunction) => Eq.refl.{1} Nat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
