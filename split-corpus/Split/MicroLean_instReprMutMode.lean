import Mathlib

set_option pp.all true
-- spec: MicroLean.instReprMutMode : Repr.{0} MicroLean.MutMode
def MicroLean.instReprMutMode : Repr.{0} MicroLean.MutMode :=
  Repr.mk.{0} MicroLean.MutMode MicroLean.instReprMutMode.repr
