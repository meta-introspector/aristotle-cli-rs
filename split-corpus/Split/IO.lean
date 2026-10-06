import Mathlib

set_option pp.all true
-- spec: IO : Type -> Type
def IO : Type -> Type :=
  EIO IO.Error
