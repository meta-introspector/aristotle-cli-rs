import Mathlib

set_option pp.all true
-- spec: Lean.Meta.Diagnostics.synthPendingFailures : Lean.Meta.Diagnostics -> (Lean.PHashMap.{0, 0} Lean.Expr Lean.MessageData Lean.Expr.instBEq Lean.Expr.instHashable)
def Lean.Meta.Diagnostics.synthPendingFailures : Lean.Meta.Diagnostics -> (Lean.PHashMap.{0, 0} Lean.Expr Lean.MessageData Lean.Expr.instBEq Lean.Expr.instHashable) :=
  fun (self : Lean.Meta.Diagnostics) => self.5
