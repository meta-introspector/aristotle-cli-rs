import Mathlib

set_option pp.all true
-- spec: Void : Type -> Type
def Void : Type -> Type :=
  fun (σ : Type) => NonemptyType.type.{0} (Void.nonemptyType σ)
