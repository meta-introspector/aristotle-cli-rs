import Mathlib

set_option pp.all true
-- spec: IO.Ref : Type -> Type
def IO.Ref : Type -> Type :=
  fun (α : Type) => ST.Ref IO.RealWorld α
