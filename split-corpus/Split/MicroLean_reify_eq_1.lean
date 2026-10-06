import Mathlib

-- spec: theorem MicroLean.reify.eq_1 : Eq.{1} Lean.Expr (MicroLean.reify MicroLean.MicroLeanType.nat) (Lean.Expr.const (Lean.Name.mkStr1 "Nat") (List.nil.{0} Lean.Level))
theorem MicroLean.reify.eq_1 : Eq.{1} Lean.Expr (MicroLean.reify MicroLean.MicroLeanType.nat) (Lean.Expr.const (Lean.Name.mkStr1 "Nat") (List.nil.{0} Lean.Level)) :=
  Eq.refl.{1} Lean.Expr (MicroLean.reify MicroLean.MicroLeanType.nat)
