import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Delaborator.DelabM : Type -> Type
def Lean.PrettyPrinter.Delaborator.DelabM : Type -> Type :=
  ReaderT.{0, 0} Lean.PrettyPrinter.Delaborator.Context (StateRefT' IO.RealWorld Lean.PrettyPrinter.Delaborator.State Lean.Meta.MetaM)
