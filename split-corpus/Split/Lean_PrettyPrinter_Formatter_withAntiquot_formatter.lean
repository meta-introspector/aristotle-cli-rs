import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Formatter.withAntiquot.formatter : Lean.PrettyPrinter.Formatter -> Lean.PrettyPrinter.Formatter -> Lean.PrettyPrinter.Formatter
def Lean.PrettyPrinter.Formatter.withAntiquot.formatter : Lean.PrettyPrinter.Formatter -> Lean.PrettyPrinter.Formatter -> Lean.PrettyPrinter.Formatter :=
  fun (antiP : Lean.PrettyPrinter.Formatter) (p : Lean.PrettyPrinter.Formatter) => Lean.PrettyPrinter.Formatter.orelse.formatter antiP p
