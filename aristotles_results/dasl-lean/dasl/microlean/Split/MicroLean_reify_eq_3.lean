import Mathlib

-- spec: theorem MicroLean.reify.eq_3 : forall (a : MicroLean.MicroLeanType) (a_1 : MicroLean.MicroLeanType), Eq.{1} Lean.Expr (MicroLean.reify (MicroLean.MicroLeanType.function a a_1)) (Lean.Expr.forallE (Lean.Name.mkStr1 "x") (MicroLean.reify a) (MicroLean.reify a_1) Lean.BinderInfo.default)
theorem MicroLean.reify.eq_3 : forall (a : MicroLean.MicroLeanType) (a_1 : MicroLean.MicroLeanType), Eq.{1} Lean.Expr (MicroLean.reify (MicroLean.MicroLeanType.function a a_1)) (Lean.Expr.forallE (Lean.Name.mkStr1 "x") (MicroLean.reify a) (MicroLean.reify a_1) Lean.BinderInfo.default) :=
  fun (a : MicroLean.MicroLeanType) (a_1 : MicroLean.MicroLeanType) => Eq.refl.{1} Lean.Expr (MicroLean.reify (MicroLean.MicroLeanType.function a a_1))
