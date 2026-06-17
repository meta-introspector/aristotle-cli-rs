import Mathlib

set_option pp.all true
-- spec: MicroLean.LinearMicroType.noConfusionType : Sort.{u} -> MicroLean.LinearMicroType -> MicroLean.LinearMicroType -> Sort.{u}
def MicroLean.LinearMicroType.noConfusionType : Sort.{u} -> MicroLean.LinearMicroType -> MicroLean.LinearMicroType -> Sort.{u} :=
  fun (P : Sort.{u}) (t : MicroLean.LinearMicroType) (t' : MicroLean.LinearMicroType) => MicroLean.LinearMicroType.casesOn.{succ u} (fun (t : MicroLean.LinearMicroType) => Sort.{u}) t (fun (mode : MicroLean.OwnershipMode) (type : MicroLean.MicroLeanType) => MicroLean.LinearMicroType.casesOn.{succ u} (fun (t : MicroLean.LinearMicroType) => Sort.{u}) t' (fun (mode_1 : MicroLean.OwnershipMode) (type_1 : MicroLean.MicroLeanType) => ((Eq.{1} MicroLean.OwnershipMode mode mode_1) -> (Eq.{1} MicroLean.MicroLeanType type type_1) -> P) -> P))
