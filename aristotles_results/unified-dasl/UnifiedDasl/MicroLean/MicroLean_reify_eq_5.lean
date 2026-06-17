import Mathlib

-- spec: theorem MicroLean.reify.eq_5 : forall (a : MicroLean.MicroLeanType) (a_1 : MicroLean.MicroLeanType), Eq.{1} Lean.Expr (MicroLean.reify (MicroLean.MicroLeanType.prod a a_1)) (Lean.Expr.app (Lean.Expr.app (Lean.Expr.const (Lean.Name.mkStr1 "Prod") (List.nil.{0} Lean.Level)) (MicroLean.reify a)) (MicroLean.reify a_1))
theorem MicroLean.reify.eq_5 : forall (a : MicroLean.MicroLeanType) (a_1 : MicroLean.MicroLeanType), Eq.{1} Lean.Expr (MicroLean.reify (MicroLean.MicroLeanType.prod a a_1)) (Lean.Expr.app (Lean.Expr.app (Lean.Expr.const (Lean.Name.mkStr1 "Prod") (List.nil.{0} Lean.Level)) (MicroLean.reify a)) (MicroLean.reify a_1)) :=
  fun (a : MicroLean.MicroLeanType) (a_1 : MicroLean.MicroLeanType) => Eq.refl.{1} Lean.Expr (MicroLean.reify (MicroLean.MicroLeanType.prod a a_1))
