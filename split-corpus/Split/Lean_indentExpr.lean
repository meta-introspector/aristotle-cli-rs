import Mathlib

set_option pp.all true
-- spec: Lean.indentExpr : Lean.Expr -> Lean.MessageData
def Lean.indentExpr : Lean.Expr -> Lean.MessageData :=
  fun (e : Lean.Expr) => Lean.indentD (Lean.MessageData.ofExpr e)
