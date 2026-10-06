import Mathlib

set_option pp.all true
-- spec: MicroLean.instDecidableEqMicroLeanType : DecidableEq.{1} MicroLean.MicroLeanType
def MicroLean.instDecidableEqMicroLeanType : DecidableEq.{1} MicroLean.MicroLeanType :=
  MicroLean.instDecidableEqMicroLeanType.decEq
