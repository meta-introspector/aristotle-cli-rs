import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.CategoryParenthesizer : Type
def Lean.PrettyPrinter.CategoryParenthesizer : Type :=
  Nat -> Lean.PrettyPrinter.Parenthesizer
