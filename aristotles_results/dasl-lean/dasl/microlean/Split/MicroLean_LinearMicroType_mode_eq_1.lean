import Mathlib

-- spec: theorem MicroLean.LinearMicroType.mode.eq_1 : forall (a : MicroLean.OwnershipMode) (a_1 : MicroLean.MicroLeanType), Eq.{1} MicroLean.OwnershipMode (MicroLean.LinearMicroType.mode (MicroLean.LinearMicroType.qualified a a_1)) a
theorem MicroLean.LinearMicroType.mode.eq_1 : forall (a : MicroLean.OwnershipMode) (a_1 : MicroLean.MicroLeanType), Eq.{1} MicroLean.OwnershipMode (MicroLean.LinearMicroType.mode (MicroLean.LinearMicroType.qualified a a_1)) a :=
  fun (a : MicroLean.OwnershipMode) (a_1 : MicroLean.MicroLeanType) => Eq.refl.{1} MicroLean.OwnershipMode (MicroLean.LinearMicroType.mode (MicroLean.LinearMicroType.qualified a a_1))
