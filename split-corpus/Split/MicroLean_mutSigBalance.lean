import Mathlib

set_option pp.all true
-- spec: MicroLean.mutSigBalance : (List.{0} MicroLean.MutLinearType) -> MicroLean.MutLinearType -> Int
def MicroLean.mutSigBalance : (List.{0} MicroLean.MutLinearType) -> MicroLean.MutLinearType -> Int :=
  fun (args : List.{0} MicroLean.MutLinearType) (ret : MicroLean.MutLinearType) => HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (List.sum.{0} Int Int.instAdd (Zero.ofOfNat0.{0} Int (instOfNat 0)) (List.map.{0, 0} MicroLean.MutLinearType Int MicroLean.mutRefBalance args)) (MicroLean.mutRefBalance ret)
