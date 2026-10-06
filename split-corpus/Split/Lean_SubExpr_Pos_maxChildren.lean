import Mathlib

set_option pp.all true
-- spec: Lean.SubExpr.Pos.maxChildren : Nat
def Lean.SubExpr.Pos.maxChildren : Nat :=
  OfNat.ofNat.{0} Nat 4 (instOfNatNat 4)
