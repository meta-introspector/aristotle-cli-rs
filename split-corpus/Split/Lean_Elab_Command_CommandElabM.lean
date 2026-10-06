import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.CommandElabM : Type -> Type
def Lean.Elab.Command.CommandElabM : Type -> Type :=
  ReaderT.{0, 0} Lean.Elab.Command.Context (StateRefT' IO.RealWorld Lean.Elab.Command.State (EIO Lean.Exception))
