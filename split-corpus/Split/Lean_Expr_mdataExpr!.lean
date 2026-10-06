import Mathlib

set_option pp.all true
-- spec: Lean.Expr.mdataExpr! : Lean.Expr -> Lean.Expr
def Lean.Expr.mdataExpr! : Lean.Expr -> Lean.Expr :=
  fun (x._@.Lean.Expr.1119530203._hygCtx._hyg.5 : Lean.Expr) => _private.Lean.Expr.0.Lean.Expr.isMData.match_1.{1} (fun (x._@.Lean.Expr.1119530203._hygCtx.5.Lean.Expr.1119530203._hygCtx._hyg.16 : Lean.Expr) => Lean.Expr) x._@.Lean.Expr.1119530203._hygCtx._hyg.5 (fun (data._@.Lean.Expr.1119530203._hygCtx._hyg.24 : Lean.MData) (e : Lean.Expr) => e) (fun (x._@.Lean.Expr.1119530203._hygCtx._hyg.30 : Lean.Expr) => panicWithPosWithDecl.{1} Lean.Expr Lean.instInhabitedExpr "Lean.Expr" "Lean.Expr.mdataExpr!" (OfNat.ofNat.{0} Nat 1066 (instOfNatNat 1066)) (OfNat.ofNat.{0} Nat 17 (instOfNatNat 17)) "mdata expression expected")
