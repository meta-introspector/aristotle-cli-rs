import Mathlib

-- spec: theorem MicroLean.exprNoBVars.eq_4 : forall (f : Lean.Expr) (a : Lean.Expr), Eq.{1} Bool (MicroLean.exprNoBVars (Lean.Expr.app f a)) (Bool.and (MicroLean.exprNoBVars f) (MicroLean.exprNoBVars a))
theorem MicroLean.exprNoBVars.eq_4 : forall (f : Lean.Expr) (a : Lean.Expr), Eq.{1} Bool (MicroLean.exprNoBVars (Lean.Expr.app f a)) (Bool.and (MicroLean.exprNoBVars f) (MicroLean.exprNoBVars a)) :=
  fun (f : Lean.Expr) (a : Lean.Expr) => Eq.refl.{1} Bool (MicroLean.exprNoBVars (Lean.Expr.app f a))
