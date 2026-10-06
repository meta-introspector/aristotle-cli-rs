import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Formatter.categoryFormatter : Lean.Name -> Lean.PrettyPrinter.Formatter
def Lean.PrettyPrinter.Formatter.categoryFormatter : Lean.Name -> Lean.PrettyPrinter.Formatter :=
  fun (cat : Lean.Name) => Lean.PrettyPrinter.Formatter.fill (Lean.PrettyPrinter.Formatter.indent (Lean.PrettyPrinter.Formatter.categoryFormatterCore cat) (Option.none.{0} Int))
