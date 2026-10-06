import Mathlib

set_option pp.all true
-- spec: Lean.Expr.isAppOf : Lean.Expr -> Lean.Name -> Bool
def Lean.Expr.isAppOf : Lean.Expr -> Lean.Name -> Bool :=
  fun (e : Lean.Expr) (n : Lean.Name) => _private.Lean.Expr.0.Lean.Expr.isConst.match_1.{1} (fun (x._@.Lean.Expr.381113271._hygCtx._hyg.8 : Lean.Expr) => Bool) (Lean.Expr.getAppFn e) (fun (c : Lean.Name) (us._@.Lean.Expr.381113271._hygCtx._hyg.16 : List.{0} Lean.Level) => BEq.beq.{0} Lean.Name Lean.Name.instBEq c n) (fun (x._@.Lean.Expr.381113271._hygCtx._hyg.25 : Lean.Expr) => Bool.false)
