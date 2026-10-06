import Mathlib

-- spec: opaque Lean.PrettyPrinter.Formatter.orelse.formatter : Lean.PrettyPrinter.Formatter -> Lean.PrettyPrinter.Formatter -> Lean.PrettyPrinter.Formatter
opaque Lean.PrettyPrinter.Formatter.orelse.formatter : Lean.PrettyPrinter.Formatter -> Lean.PrettyPrinter.Formatter -> Lean.PrettyPrinter.Formatter :=
  fun (p1 : Lean.PrettyPrinter.Formatter) (p2 : Lean.PrettyPrinter.Formatter) => let inst : Inhabited.{1} Lean.PrettyPrinter.Formatter := Inhabited.mk.{1} Lean.PrettyPrinter.Formatter p2; Inhabited.default.{1} Lean.PrettyPrinter.Formatter inst
