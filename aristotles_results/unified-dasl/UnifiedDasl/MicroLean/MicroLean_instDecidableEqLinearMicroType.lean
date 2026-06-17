import Mathlib

set_option pp.all true
-- spec: MicroLean.instDecidableEqLinearMicroType : DecidableEq.{1} MicroLean.LinearMicroType
def MicroLean.instDecidableEqLinearMicroType : DecidableEq.{1} MicroLean.LinearMicroType :=
  MicroLean.instDecidableEqLinearMicroType.decEq
