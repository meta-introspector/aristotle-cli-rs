import Mathlib

set_option pp.all true
-- spec: MicroLean.instReprOwnershipMode : Repr.{0} MicroLean.OwnershipMode
def MicroLean.instReprOwnershipMode : Repr.{0} MicroLean.OwnershipMode :=
  Repr.mk.{0} MicroLean.OwnershipMode MicroLean.instReprOwnershipMode.repr
