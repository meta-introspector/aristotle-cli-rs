import Mathlib

set_option pp.all true
-- spec: Lean.Expr.headBeta : Lean.Expr -> Lean.Expr
def Lean.Expr.headBeta : Lean.Expr -> Lean.Expr :=
  fun (e : Lean.Expr) => have f : Lean.Expr := Lean.Expr.getAppFn e; ite.{1} Lean.Expr (Eq.{1} Bool (Lean.Expr.isHeadBetaTargetFn Bool.false f) Bool.true) (instDecidableEqBool (Lean.Expr.isHeadBetaTargetFn Bool.false f) Bool.true) (Lean.Expr.betaRev f (Lean.Expr.getAppRevArgs e) Bool.false Bool.false) e
