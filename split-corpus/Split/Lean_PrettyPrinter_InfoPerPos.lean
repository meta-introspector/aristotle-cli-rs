import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.InfoPerPos : Type
def Lean.PrettyPrinter.InfoPerPos : Type :=
  Std.TreeMap.{0, 0} Nat Lean.Elab.Info (Ord.compare.{0} Nat instOrdNat)
