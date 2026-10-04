import Mathlib

set_option pp.all true
-- spec: Lean.Expr.Data.approxDepth : Lean.Expr.Data -> UInt8
def Lean.Expr.Data.approxDepth : Lean.Expr.Data -> UInt8 :=
  fun (c : Lean.Expr.Data) => UInt64.toUInt8 (UInt64.land (UInt64.shiftRight c (OfNat.ofNat.{0} UInt64 32 (UInt64.instOfNat 32))) (OfNat.ofNat.{0} UInt64 255 (UInt64.instOfNat 255)))
