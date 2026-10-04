import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Formatter : Type
def Lean.PrettyPrinter.Formatter : Type :=
  Lean.PrettyPrinter.FormatterM Unit
