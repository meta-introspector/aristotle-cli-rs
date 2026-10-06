import Mathlib

-- spec: opaque Lean.PrettyPrinter.categoryParenthesizerAttribute : Lean.KeyedDeclsAttribute Lean.PrettyPrinter.CategoryParenthesizer
opaque Lean.PrettyPrinter.categoryParenthesizerAttribute : Lean.KeyedDeclsAttribute Lean.PrettyPrinter.CategoryParenthesizer :=
  Classical.ofNonempty.{1} (Lean.KeyedDeclsAttribute Lean.PrettyPrinter.CategoryParenthesizer) (Lean.instNonemptyKeyedDeclsAttribute Lean.PrettyPrinter.CategoryParenthesizer)
