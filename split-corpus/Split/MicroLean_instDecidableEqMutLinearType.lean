import Mathlib

set_option pp.all true
-- spec: MicroLean.instDecidableEqMutLinearType : DecidableEq.{1} MicroLean.MutLinearType
def MicroLean.instDecidableEqMutLinearType : DecidableEq.{1} MicroLean.MutLinearType :=
  MicroLean.instDecidableEqMutLinearType.decEq
