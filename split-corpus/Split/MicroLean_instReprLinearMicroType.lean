import Mathlib

set_option pp.all true
-- spec: MicroLean.instReprLinearMicroType : Repr.{0} MicroLean.LinearMicroType
def MicroLean.instReprLinearMicroType : Repr.{0} MicroLean.LinearMicroType :=
  Repr.mk.{0} MicroLean.LinearMicroType MicroLean.instReprLinearMicroType.repr
