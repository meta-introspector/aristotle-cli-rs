import Mathlib

set_option pp.all true
-- spec: MicroLean.mutRefBalance : MicroLean.MutLinearType -> Int
def MicroLean.mutRefBalance : MicroLean.MutLinearType -> Int :=
  fun (lt : MicroLean.MutLinearType) => HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (MicroLean.mutCallerInc lt) (MicroLean.mutCalleeDec lt)
