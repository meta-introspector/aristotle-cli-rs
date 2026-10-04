import Mathlib

-- spec: theorem Expr.SelfRef.sizeOf_spec : Eq.{1} Nat (SizeOf.sizeOf.{1} Expr Expr._sizeOf_inst Expr.SelfRef) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
theorem Expr.SelfRef.sizeOf_spec : Eq.{1} Nat (SizeOf.sizeOf.{1} Expr Expr._sizeOf_inst Expr.SelfRef) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) :=
  Eq.refl.{1} Nat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))
