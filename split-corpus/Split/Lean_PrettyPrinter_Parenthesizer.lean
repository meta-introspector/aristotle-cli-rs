import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Parenthesizer : Type
def Lean.PrettyPrinter.Parenthesizer : Type :=
  Lean.PrettyPrinter.ParenthesizerM Unit
