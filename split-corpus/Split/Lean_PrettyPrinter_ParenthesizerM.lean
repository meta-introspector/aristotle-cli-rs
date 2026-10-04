import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.ParenthesizerM : Type -> Type
def Lean.PrettyPrinter.ParenthesizerM : Type -> Type :=
  ReaderT.{0, 0} Lean.PrettyPrinter.Parenthesizer.Context (StateRefT' IO.RealWorld Lean.PrettyPrinter.Parenthesizer.State Lean.Core.CoreM)
