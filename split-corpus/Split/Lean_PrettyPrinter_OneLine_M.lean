import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.OneLine.M : Type -> Type
def Lean.PrettyPrinter.OneLine.M : Type -> Type :=
  EStateM.{0} Unit Lean.PrettyPrinter.OneLine.State
