import Mathlib

set_option pp.all true
-- spec: Lean.SubExpr.Pos.root : Lean.SubExpr.Pos
def Lean.SubExpr.Pos.root : Lean.SubExpr.Pos :=
  OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)
