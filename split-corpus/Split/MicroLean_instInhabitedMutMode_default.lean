import Mathlib

set_option pp.all true
-- spec: MicroLean.instInhabitedMutMode.default : MicroLean.MutMode
def MicroLean.instInhabitedMutMode.default : MicroLean.MutMode :=
  MicroLean.MutMode.borrowed
