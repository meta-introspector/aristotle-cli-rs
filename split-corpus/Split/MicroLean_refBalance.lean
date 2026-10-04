import Mathlib

set_option pp.all true
-- spec: MicroLean.refBalance : MicroLean.LinearMicroType -> Int
def MicroLean.refBalance : MicroLean.LinearMicroType -> Int :=
  fun (lt : MicroLean.LinearMicroType) => HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (MicroLean.callerInc lt) (MicroLean.calleeDec lt)
