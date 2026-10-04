import Mathlib

-- spec: opaque Lean.PrettyPrinter.Delaborator.delab : Lean.PrettyPrinter.Delaborator.Delab
opaque Lean.PrettyPrinter.Delaborator.delab : Lean.PrettyPrinter.Delaborator.Delab :=
  Inhabited.default.{1} Lean.PrettyPrinter.Delaborator.Delab (Lean.PrettyPrinter.Delaborator.instInhabitedDelabM Lean.Syntax.Term)
