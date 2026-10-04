import Mathlib

set_option pp.all true
-- spec: BaseIO : Type -> Type
def BaseIO : Type -> Type :=
  fun (α : Type) => ST IO.RealWorld α
