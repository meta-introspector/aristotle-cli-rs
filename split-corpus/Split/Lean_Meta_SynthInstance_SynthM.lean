import Mathlib

set_option pp.all true
-- spec: Lean.Meta.SynthInstance.SynthM : Type -> Type
def Lean.Meta.SynthInstance.SynthM : Type -> Type :=
  ReaderT.{0, 0} Lean.Meta.SynthInstance.Context (StateRefT' IO.RealWorld Lean.Meta.SynthInstance.State Lean.Meta.MetaM)
