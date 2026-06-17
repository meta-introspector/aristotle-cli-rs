import Mathlib

-- spec: theorem MicroLean.linearMemOps_borrowed : forall (t : MicroLean.MicroLeanType) (var : String), Eq.{1} (List.{0} String) (MicroLean.linearMemOps (MicroLean.LinearMicroType.qualified MicroLean.OwnershipMode.borrowed t) var) (List.nil.{0} String)
theorem MicroLean.linearMemOps_borrowed : forall (t : MicroLean.MicroLeanType) (var : String), Eq.{1} (List.{0} String) (MicroLean.linearMemOps (MicroLean.LinearMicroType.qualified MicroLean.OwnershipMode.borrowed t) var) (List.nil.{0} String) :=
  fun (t : MicroLean.MicroLeanType) (var : String) => Eq.refl.{1} (List.{0} String) (MicroLean.linearMemOps (MicroLean.LinearMicroType.qualified MicroLean.OwnershipMode.borrowed t) var)
