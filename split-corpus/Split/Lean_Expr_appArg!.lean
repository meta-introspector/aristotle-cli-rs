import Mathlib

set_option pp.all true
-- spec: Lean.Expr.appArg! : Lean.Expr -> Lean.Expr
def Lean.Expr.appArg! : Lean.Expr -> Lean.Expr :=
  fun (x._@.Lean.Expr.3593901344._hygCtx._hyg.5 : Lean.Expr) => _private.Lean.Expr.0.Lean.Expr.isApp.match_1.{1} (fun (x._@.Lean.Expr.3593901344._hygCtx.5.Lean.Expr.3593901344._hygCtx._hyg.16 : Lean.Expr) => Lean.Expr) x._@.Lean.Expr.3593901344._hygCtx._hyg.5 (fun (fn._@.Lean.Expr.3593901344._hygCtx._hyg.24 : Lean.Expr) (a : Lean.Expr) => a) (fun (x._@.Lean.Expr.3593901344._hygCtx._hyg.30 : Lean.Expr) => panicWithPosWithDecl.{1} Lean.Expr Lean.instInhabitedExpr "Lean.Expr" "Lean.Expr.appArg!" (OfNat.ofNat.{0} Nat 920 (instOfNatNat 920)) (OfNat.ofNat.{0} Nat 15 (instOfNatNat 15)) "application expected")
