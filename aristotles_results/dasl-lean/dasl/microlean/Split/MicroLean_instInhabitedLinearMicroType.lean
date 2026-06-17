import Mathlib

set_option pp.all true
-- spec: MicroLean.instInhabitedLinearMicroType : Inhabited.{1} MicroLean.LinearMicroType
def MicroLean.instInhabitedLinearMicroType : Inhabited.{1} MicroLean.LinearMicroType :=
  Inhabited.mk.{1} MicroLean.LinearMicroType MicroLean.instInhabitedLinearMicroType.default
