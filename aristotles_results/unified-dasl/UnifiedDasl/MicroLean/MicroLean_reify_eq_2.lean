import Mathlib

-- spec: theorem MicroLean.reify.eq_2 : Eq.{1} Lean.Expr (MicroLean.reify MicroLean.MicroLeanType.bool) (Lean.Expr.const (Lean.Name.mkStr1 "Bool") (List.nil.{0} Lean.Level))
theorem MicroLean.reify.eq_2 : Eq.{1} Lean.Expr (MicroLean.reify MicroLean.MicroLeanType.bool) (Lean.Expr.const (Lean.Name.mkStr1 "Bool") (List.nil.{0} Lean.Level)) :=
  Eq.refl.{1} Lean.Expr (MicroLean.reify MicroLean.MicroLeanType.bool)
