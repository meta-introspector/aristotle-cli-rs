import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.formatCategory : Lean.Name -> Lean.Syntax -> (Lean.Core.CoreM Std.Format)
def Lean.PrettyPrinter.formatCategory : Lean.Name -> Lean.Syntax -> (Lean.Core.CoreM Std.Format) :=
  fun (cat : Lean.Name) => Lean.PrettyPrinter.format (Lean.PrettyPrinter.Formatter.categoryFormatter cat)
