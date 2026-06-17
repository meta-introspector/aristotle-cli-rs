import Mathlib

-- spec: theorem MicroLean.exprNoBVars.eq_3 : forall (binderName : Lean.Name) (d : Lean.Expr) (b : Lean.Expr) (binderInfo : Lean.BinderInfo), Eq.{1} Bool (MicroLean.exprNoBVars (Lean.Expr.lam binderName d b binderInfo)) (Bool.and (MicroLean.exprNoBVars d) (MicroLean.exprNoBVars b))
theorem MicroLean.exprNoBVars.eq_3 : forall (binderName : Lean.Name) (d : Lean.Expr) (b : Lean.Expr) (binderInfo : Lean.BinderInfo), Eq.{1} Bool (MicroLean.exprNoBVars (Lean.Expr.lam binderName d b binderInfo)) (Bool.and (MicroLean.exprNoBVars d) (MicroLean.exprNoBVars b)) :=
  fun (binderName : Lean.Name) (d : Lean.Expr) (b : Lean.Expr) (binderInfo : Lean.BinderInfo) => Eq.refl.{1} Bool (MicroLean.exprNoBVars (Lean.Expr.lam binderName d b binderInfo))
