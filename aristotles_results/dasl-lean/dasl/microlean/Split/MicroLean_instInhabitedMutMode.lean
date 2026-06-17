import Mathlib

set_option pp.all true
-- spec: MicroLean.instInhabitedMutMode : Inhabited.{1} MicroLean.MutMode
def MicroLean.instInhabitedMutMode : Inhabited.{1} MicroLean.MutMode :=
  Inhabited.mk.{1} MicroLean.MutMode MicroLean.instInhabitedMutMode.default
