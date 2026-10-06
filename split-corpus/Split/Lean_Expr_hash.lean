import Mathlib

set_option pp.all true
-- spec: Lean.Expr.hash : Lean.Expr -> UInt64
def Lean.Expr.hash : Lean.Expr -> UInt64 :=
  fun (e : Lean.Expr) => Lean.Expr.Data.hash (Lean.Expr.data e)
