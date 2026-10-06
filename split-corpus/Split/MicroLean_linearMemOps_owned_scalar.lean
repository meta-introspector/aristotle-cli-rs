import Mathlib

-- spec: theorem MicroLean.linearMemOps_owned_scalar : forall (var : String), Eq.{1} (List.{0} String) (MicroLean.linearMemOps (MicroLean.LinearMicroType.qualified MicroLean.OwnershipMode.owned MicroLean.MicroLeanType.bool) var) (List.nil.{0} String)
theorem MicroLean.linearMemOps_owned_scalar : forall (var : String), Eq.{1} (List.{0} String) (MicroLean.linearMemOps (MicroLean.LinearMicroType.qualified MicroLean.OwnershipMode.owned MicroLean.MicroLeanType.bool) var) (List.nil.{0} String) :=
  fun (var : String) => Eq.refl.{1} (List.{0} String) (MicroLean.linearMemOps (MicroLean.LinearMicroType.qualified MicroLean.OwnershipMode.owned MicroLean.MicroLeanType.bool) var)
