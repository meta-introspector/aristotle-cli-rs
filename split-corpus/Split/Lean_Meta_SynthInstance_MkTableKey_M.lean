import Mathlib

set_option pp.all true
-- spec: Lean.Meta.SynthInstance.MkTableKey.M : Type -> Type
def Lean.Meta.SynthInstance.MkTableKey.M : Type -> Type :=
  StateM.{0} Lean.Meta.SynthInstance.MkTableKey.State
