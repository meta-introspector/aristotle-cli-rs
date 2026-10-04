import Mathlib

set_option pp.all true
-- spec: Lean.Expr.constName! : Lean.Expr -> Lean.Name
def Lean.Expr.constName! : Lean.Expr -> Lean.Name :=
  fun (x._@.Lean.Expr.3035886738._hygCtx._hyg.5 : Lean.Expr) => _private.Lean.Expr.0.Lean.Expr.isConst.match_1.{1} (fun (x._@.Lean.Expr.3035886738._hygCtx.5.Lean.Expr.3035886738._hygCtx._hyg.16 : Lean.Expr) => Lean.Name) x._@.Lean.Expr.3035886738._hygCtx._hyg.5 (fun (n : Lean.Name) (us._@.Lean.Expr.3035886738._hygCtx._hyg.24 : List.{0} Lean.Level) => n) (fun (x._@.Lean.Expr.3035886738._hygCtx._hyg.30 : Lean.Expr) => panicWithPosWithDecl.{1} Lean.Name Lean.instInhabitedName "Lean.Expr" "Lean.Expr.constName!" (OfNat.ofNat.{0} Nat 970 (instOfNatNat 970)) (OfNat.ofNat.{0} Nat 17 (instOfNatNat 17)) "constant expected")
