import Mathlib

-- spec: theorem MicroLean.exprNoBVars.eq_1 : forall (deBruijnIndex : Nat), Eq.{1} Bool (MicroLean.exprNoBVars (Lean.Expr.bvar deBruijnIndex)) Bool.false
theorem MicroLean.exprNoBVars.eq_1 : forall (deBruijnIndex : Nat), Eq.{1} Bool (MicroLean.exprNoBVars (Lean.Expr.bvar deBruijnIndex)) Bool.false :=
  fun (deBruijnIndex : Nat) => Eq.refl.{1} Bool (MicroLean.exprNoBVars (Lean.Expr.bvar deBruijnIndex))
