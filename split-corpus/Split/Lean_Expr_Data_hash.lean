import Mathlib

set_option pp.all true
-- spec: Lean.Expr.Data.hash : Lean.Expr.Data -> UInt64
def Lean.Expr.Data.hash : Lean.Expr.Data -> UInt64 :=
  fun (c : Lean.Expr.Data) => UInt32.toUInt64 (UInt64.toUInt32 c)
