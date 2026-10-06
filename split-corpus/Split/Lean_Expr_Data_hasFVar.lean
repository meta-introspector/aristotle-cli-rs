import Mathlib

set_option pp.all true
-- spec: Lean.Expr.Data.hasFVar : Lean.Expr.Data -> Bool
def Lean.Expr.Data.hasFVar : Lean.Expr.Data -> Bool :=
  fun (c : Lean.Expr.Data) => BEq.beq.{0} UInt64 (instBEqOfDecidableEq.{0} UInt64 instDecidableEqUInt64) (UInt64.land (UInt64.shiftRight c (OfNat.ofNat.{0} UInt64 40 (UInt64.instOfNat 40))) (OfNat.ofNat.{0} UInt64 1 (UInt64.instOfNat 1))) (OfNat.ofNat.{0} UInt64 1 (UInt64.instOfNat 1))
