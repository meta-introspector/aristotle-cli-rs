import Mathlib

-- spec: theorem MicroLean.reify.eq_4 : forall (a : MicroLean.MicroLeanType), Eq.{1} Lean.Expr (MicroLean.reify (MicroLean.MicroLeanType.array a)) (Lean.Expr.app (Lean.Expr.const (Lean.Name.mkStr1 "Array") (List.nil.{0} Lean.Level)) (MicroLean.reify a))
theorem MicroLean.reify.eq_4 : forall (a : MicroLean.MicroLeanType), Eq.{1} Lean.Expr (MicroLean.reify (MicroLean.MicroLeanType.array a)) (Lean.Expr.app (Lean.Expr.const (Lean.Name.mkStr1 "Array") (List.nil.{0} Lean.Level)) (MicroLean.reify a)) :=
  fun (a : MicroLean.MicroLeanType) => Eq.refl.{1} Lean.Expr (MicroLean.reify (MicroLean.MicroLeanType.array a))
