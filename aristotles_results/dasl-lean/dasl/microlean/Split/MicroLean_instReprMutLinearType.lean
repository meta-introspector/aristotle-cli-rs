import Mathlib

set_option pp.all true
-- spec: MicroLean.instReprMutLinearType : Repr.{0} MicroLean.MutLinearType
def MicroLean.instReprMutLinearType : Repr.{0} MicroLean.MutLinearType :=
  Repr.mk.{0} MicroLean.MutLinearType MicroLean.instReprMutLinearType.repr
