import Mathlib

set_option pp.all true
-- spec: Lean.AttrM : Type -> Type
def Lean.AttrM : Type -> Type :=
  Lean.Core.CoreM
