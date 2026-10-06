import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.FormatterM : Type -> Type
def Lean.PrettyPrinter.FormatterM : Type -> Type :=
  ReaderT.{0, 0} Lean.PrettyPrinter.Formatter.Context (StateRefT' IO.RealWorld Lean.PrettyPrinter.Formatter.State Lean.Core.CoreM)
