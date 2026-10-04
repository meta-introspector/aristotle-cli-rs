import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Delaborator.Delab : Type
def Lean.PrettyPrinter.Delaborator.Delab : Type :=
  Lean.PrettyPrinter.Delaborator.DelabM Lean.Syntax.Term
