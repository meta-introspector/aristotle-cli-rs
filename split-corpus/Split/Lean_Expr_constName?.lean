import Mathlib

set_option pp.all true
-- spec: Lean.Expr.constName? : Lean.Expr -> (Option.{0} Lean.Name)
def Lean.Expr.constName? : Lean.Expr -> (Option.{0} Lean.Name) :=
  fun (x._@.Lean.Expr.3829855332._hygCtx._hyg.6 : Lean.Expr) => _private.Lean.Expr.0.Lean.Expr.isConst.match_1.{1} (fun (x._@.Lean.Expr.3829855332._hygCtx.6.Lean.Expr.3829855332._hygCtx._hyg.17 : Lean.Expr) => Option.{0} Lean.Name) x._@.Lean.Expr.3829855332._hygCtx._hyg.6 (fun (n : Lean.Name) (us._@.Lean.Expr.3829855332._hygCtx._hyg.25 : List.{0} Lean.Level) => Option.some.{0} Lean.Name n) (fun (x._@.Lean.Expr.3829855332._hygCtx._hyg.32 : Lean.Expr) => Option.none.{0} Lean.Name)
