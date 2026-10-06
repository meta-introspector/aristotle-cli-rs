import Mathlib

set_option pp.all true
-- spec: Lean.Core.CoreM : Type -> Type
def Lean.Core.CoreM : Type -> Type :=
  ReaderT.{0, 0} Lean.Core.Context (StateRefT' IO.RealWorld Lean.Core.State (EIO Lean.Exception))
