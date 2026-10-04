import Mathlib

set_option pp.all true
-- spec: Lean.SubExpr.PosMap : Type.{u} -> Sort.{max 1 (succ u)}
def Lean.SubExpr.PosMap : Type.{u} -> Sort.{max 1 (succ u)} :=
  fun (α : Type.{u}) => Std.TreeMap.{0, u} Lean.SubExpr.Pos α (Ord.compare.{0} Lean.SubExpr.Pos Lean.SubExpr.Pos.instOrd)
