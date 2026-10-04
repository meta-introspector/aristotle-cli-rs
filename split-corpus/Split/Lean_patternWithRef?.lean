import Mathlib

set_option pp.all true
-- spec: Lean.patternWithRef? : Lean.Expr -> (Option.{0} (Prod.{0, 0} Lean.Syntax Lean.Expr))
def Lean.patternWithRef? : Lean.Expr -> (Option.{0} (Prod.{0, 0} Lean.Syntax Lean.Expr)) :=
  fun (p : Lean.Expr) => _private.Lean.Expr.0.Lean.Expr.isMData.match_1.{1} (fun (p._@.Lean.Expr.1012331914._hygCtx._hyg.14 : Lean.Expr) => Option.{0} (Prod.{0, 0} Lean.Syntax Lean.Expr)) p (fun (d : Lean.MData) (expr._@.Lean.Expr.1012331914._hygCtx._hyg.22 : Lean.Expr) => _private.Lean.Expr.0.Lean.patternWithRef?.match_1.{1} (fun (x._@.Lean.Expr.1012331914._hygCtx._hyg.31 : Option.{0} Lean.DataValue) => Option.{0} (Prod.{0, 0} Lean.Syntax Lean.Expr)) (Lean.KVMap.find d _private.Lean.Expr.0.Lean.patternRefAnnotationKey) (fun (stx : Lean.Syntax) => Option.some.{0} (Prod.{0, 0} Lean.Syntax Lean.Expr) (Prod.mk.{0, 0} Lean.Syntax Lean.Expr stx (Lean.Expr.mdataExpr! p))) (fun (x._@.Lean.Expr.1012331914._hygCtx._hyg.49 : Option.{0} Lean.DataValue) => Option.none.{0} (Prod.{0, 0} Lean.Syntax Lean.Expr))) (fun (x._@.Lean.Expr.1012331914._hygCtx._hyg.62 : Lean.Expr) => Option.none.{0} (Prod.{0, 0} Lean.Syntax Lean.Expr))
