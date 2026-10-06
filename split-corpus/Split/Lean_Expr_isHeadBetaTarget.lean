import Mathlib

set_option pp.all true
-- spec: Lean.Expr.isHeadBetaTarget : Lean.Expr -> (optParam.{1} Bool Bool.false) -> Bool
def Lean.Expr.isHeadBetaTarget : Lean.Expr -> (optParam.{1} Bool Bool.false) -> Bool :=
  fun (e : Lean.Expr) (useZeta : Bool) => Bool.and (Lean.Expr.isApp e) (Lean.Expr.isHeadBetaTargetFn useZeta (Lean.Expr.getAppFn e))
