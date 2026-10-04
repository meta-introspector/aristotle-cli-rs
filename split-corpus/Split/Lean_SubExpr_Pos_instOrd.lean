import Mathlib

set_option pp.all true
-- spec: Lean.SubExpr.Pos.instOrd : Ord.{0} Lean.SubExpr.Pos
def Lean.SubExpr.Pos.instOrd : Ord.{0} Lean.SubExpr.Pos :=
  have this : Ord.{0} Nat := inferInstance.{1} (Ord.{0} Nat) instOrdNat; this
