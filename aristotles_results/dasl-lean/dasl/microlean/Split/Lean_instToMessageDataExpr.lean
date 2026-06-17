import Mathlib

set_option pp.all true
-- spec: Lean.instToMessageDataExpr : Lean.ToMessageData Lean.Expr
def Lean.instToMessageDataExpr : Lean.ToMessageData Lean.Expr :=
  Lean.ToMessageData.mk Lean.Expr Lean.MessageData.ofExpr
