import Mathlib

set_option pp.all true
-- spec: EIO : Type -> Type -> Type
def EIO : Type -> Type -> Type :=
  fun (ε : Type) (α : Type) => EST ε IO.RealWorld α
