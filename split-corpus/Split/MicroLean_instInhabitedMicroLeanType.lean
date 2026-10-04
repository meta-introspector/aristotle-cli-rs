import Mathlib

set_option pp.all true
-- spec: MicroLean.instInhabitedMicroLeanType : Inhabited.{1} MicroLean.MicroLeanType
def MicroLean.instInhabitedMicroLeanType : Inhabited.{1} MicroLean.MicroLeanType :=
  Inhabited.mk.{1} MicroLean.MicroLeanType MicroLean.instInhabitedMicroLeanType.default
