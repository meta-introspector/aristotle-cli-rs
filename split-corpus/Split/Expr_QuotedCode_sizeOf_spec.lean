import Mathlib

-- spec: theorem Expr.QuotedCode.sizeOf_spec : forall (a._@._internal._hyg.0 : Expr), Eq.{1} Nat (SizeOf.sizeOf.{1} Expr Expr._sizeOf_inst (Expr.QuotedCode a._@._internal._hyg.0)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} Expr Expr._sizeOf_inst a._@._internal._hyg.0))
theorem Expr.QuotedCode.sizeOf_spec : forall (a._@._internal._hyg.0 : Expr), Eq.{1} Nat (SizeOf.sizeOf.{1} Expr Expr._sizeOf_inst (Expr.QuotedCode a._@._internal._hyg.0)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} Expr Expr._sizeOf_inst a._@._internal._hyg.0)) :=
  fun (a._@._internal._hyg.0 : Expr) => Eq.refl.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} Expr Expr._sizeOf_inst a._@._internal._hyg.0))
