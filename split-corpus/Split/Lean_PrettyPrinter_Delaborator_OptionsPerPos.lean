import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Delaborator.OptionsPerPos : Type
def Lean.PrettyPrinter.Delaborator.OptionsPerPos : Type :=
  Std.TreeMap.{0, 0} Lean.SubExpr.Pos Lean.Options (Ord.compare.{0} Lean.SubExpr.Pos Lean.SubExpr.Pos.instOrd)
