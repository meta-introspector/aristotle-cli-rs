import Mathlib

set_option pp.all true
-- spec: MicroLean.instReprMicroLeanType : Repr.{0} MicroLean.MicroLeanType
def MicroLean.instReprMicroLeanType : Repr.{0} MicroLean.MicroLeanType :=
  Repr.mk.{0} MicroLean.MicroLeanType MicroLean.instReprMicroLeanType.repr
