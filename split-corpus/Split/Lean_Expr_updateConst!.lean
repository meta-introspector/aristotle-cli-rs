import Mathlib

set_option pp.all true
-- spec: Lean.Expr.updateConst! : Lean.Expr -> (List.{0} Lean.Level) -> Lean.Expr
def Lean.Expr.updateConst! : Lean.Expr -> (List.{0} Lean.Level) -> Lean.Expr :=
  fun (e : Lean.Expr) (newLevels : List.{0} Lean.Level) => _private.Lean.Expr.0.Lean.Expr.isConst.match_1.{1} (fun (e._@.Lean.Expr.227316259._hygCtx._hyg.9 : Lean.Expr) => Lean.Expr) e (fun (n : Lean.Name) (us._@.Lean.Expr.227316259._hygCtx._hyg.17 : List.{0} Lean.Level) => Lean.mkConst n newLevels) (fun (x._@.Lean.Expr.227316259._hygCtx._hyg.24 : Lean.Expr) => panicWithPosWithDecl.{1} Lean.Expr Lean.instInhabitedExpr "Lean.Expr" "Lean.Expr.updateConst!" (OfNat.ofNat.{0} Nat 1839 (instOfNatNat 1839)) (OfNat.ofNat.{0} Nat 17 (instOfNatNat 17)) "constant expected")
