import Mathlib

set_option pp.all true
-- spec: Lean.instToMessageDataOptionExpr : Lean.ToMessageData (Option.{0} Lean.Expr)
def Lean.instToMessageDataOptionExpr : Lean.ToMessageData (Option.{0} Lean.Expr) :=
  Lean.ToMessageData.mk (Option.{0} Lean.Expr) (fun (x._@.Lean.Message.3731148169._hygCtx._hyg.11 : Option.{0} Lean.Expr) => Lean.MessageData.instCoeOptionExpr.match_1.{1} (fun (x._@.Lean.Message.3731148169._hygCtx.11.Lean.Message.3731148169._hygCtx._hyg.20 : Option.{0} Lean.Expr) => Lean.MessageData) x._@.Lean.Message.3731148169._hygCtx._hyg.11 (fun (_ : Unit) => Function.comp.{1, 1, 1} String Std.Format Lean.MessageData Lean.MessageData.ofFormat (Std.ToFormat.format.{0} String Std.instToFormatString) "<not-available>") (fun (e : Lean.Expr) => Lean.ToMessageData.toMessageData Lean.Expr Lean.instToMessageDataExpr e))
