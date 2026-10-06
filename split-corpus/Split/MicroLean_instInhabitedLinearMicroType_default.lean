import Mathlib

set_option pp.all true
-- spec: MicroLean.instInhabitedLinearMicroType.default : MicroLean.LinearMicroType
def MicroLean.instInhabitedLinearMicroType.default : MicroLean.LinearMicroType :=
  MicroLean.LinearMicroType.qualified (Inhabited.default.{1} MicroLean.OwnershipMode MicroLean.instInhabitedOwnershipMode) (Inhabited.default.{1} MicroLean.MicroLeanType MicroLean.instInhabitedMicroLeanType)
