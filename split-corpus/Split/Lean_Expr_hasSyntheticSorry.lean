import Mathlib

set_option pp.all true
-- spec: Lean.Expr.hasSyntheticSorry : Lean.Expr -> Bool
def Lean.Expr.hasSyntheticSorry : Lean.Expr -> Bool :=
  fun (e : Lean.Expr) => Option.isSome.{0} Lean.Expr (Lean.Expr.find? (fun (x._@.Lean.Util.Sorry.605537440._hygCtx._hyg.10 : Lean.Expr) => Lean.Expr.isSyntheticSorry x._@.Lean.Util.Sorry.605537440._hygCtx._hyg.10) e)
