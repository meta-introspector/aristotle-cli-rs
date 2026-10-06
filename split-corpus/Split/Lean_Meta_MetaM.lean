import Mathlib

set_option pp.all true
-- spec: Lean.Meta.MetaM : Type -> Type
def Lean.Meta.MetaM : Type -> Type :=
  ReaderT.{0, 0} Lean.Meta.Context (StateRefT' IO.RealWorld Lean.Meta.State Lean.Core.CoreM)
