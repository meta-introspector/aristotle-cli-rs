import Mathlib

set_option pp.all true
-- spec: IO.Error.instToString : ToString.{0} IO.Error
def IO.Error.instToString : ToString.{0} IO.Error :=
  ToString.mk.{0} IO.Error IO.Error.toString
