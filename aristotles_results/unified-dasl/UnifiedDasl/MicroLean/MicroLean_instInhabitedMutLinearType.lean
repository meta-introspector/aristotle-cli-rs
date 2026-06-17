import Mathlib

set_option pp.all true
-- spec: MicroLean.instInhabitedMutLinearType : Inhabited.{1} MicroLean.MutLinearType
def MicroLean.instInhabitedMutLinearType : Inhabited.{1} MicroLean.MutLinearType :=
  Inhabited.mk.{1} MicroLean.MutLinearType MicroLean.instInhabitedMutLinearType.default
