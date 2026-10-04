import Mathlib

set_option pp.all true
-- spec: IO.RealWorld : Type
def IO.RealWorld : Type :=
  NonemptyType.type.{0} IO.RealWorld.nonemptyType
