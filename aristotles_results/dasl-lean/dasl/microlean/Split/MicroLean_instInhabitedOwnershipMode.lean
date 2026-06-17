import Mathlib

set_option pp.all true
-- spec: MicroLean.instInhabitedOwnershipMode : Inhabited.{1} MicroLean.OwnershipMode
def MicroLean.instInhabitedOwnershipMode : Inhabited.{1} MicroLean.OwnershipMode :=
  Inhabited.mk.{1} MicroLean.OwnershipMode MicroLean.instInhabitedOwnershipMode.default
