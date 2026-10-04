import Mathlib

set_option pp.all true
-- spec: MicroLean.sigBalance : (List.{0} MicroLean.LinearMicroType) -> MicroLean.LinearMicroType -> Int
def MicroLean.sigBalance : (List.{0} MicroLean.LinearMicroType) -> MicroLean.LinearMicroType -> Int :=
  fun (args : List.{0} MicroLean.LinearMicroType) (ret : MicroLean.LinearMicroType) => HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (List.sum.{0} Int Int.instAdd (Zero.ofOfNat0.{0} Int (instOfNat 0)) (List.map.{0, 0} MicroLean.LinearMicroType Int MicroLean.refBalance args)) (MicroLean.refBalance ret)
