import Mathlib

set_option pp.all true
-- spec: Lean.Expr.Data.looseBVarRange : Lean.Expr.Data -> UInt32
def Lean.Expr.Data.looseBVarRange : Lean.Expr.Data -> UInt32 :=
  fun (c : Lean.Expr.Data) => UInt64.toUInt32 (UInt64.shiftRight c (OfNat.ofNat.{0} UInt64 44 (UInt64.instOfNat 44)))
