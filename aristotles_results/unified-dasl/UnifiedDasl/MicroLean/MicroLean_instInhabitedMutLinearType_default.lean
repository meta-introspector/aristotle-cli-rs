import Mathlib

set_option pp.all true
-- spec: MicroLean.instInhabitedMutLinearType.default : MicroLean.MutLinearType
def MicroLean.instInhabitedMutLinearType.default : MicroLean.MutLinearType :=
  MicroLean.MutLinearType.qualified (Inhabited.default.{1} MicroLean.MutMode MicroLean.instInhabitedMutMode) (Inhabited.default.{1} MicroLean.MicroLeanType MicroLean.instInhabitedMicroLeanType)
