import Mathlib

-- spec: theorem MicroLean.LinearMicroType.base.eq_1 : forall (a : MicroLean.OwnershipMode) (a_1 : MicroLean.MicroLeanType), Eq.{1} MicroLean.MicroLeanType (MicroLean.LinearMicroType.base (MicroLean.LinearMicroType.qualified a a_1)) a_1
theorem MicroLean.LinearMicroType.base.eq_1 : forall (a : MicroLean.OwnershipMode) (a_1 : MicroLean.MicroLeanType), Eq.{1} MicroLean.MicroLeanType (MicroLean.LinearMicroType.base (MicroLean.LinearMicroType.qualified a a_1)) a_1 :=
  fun (a : MicroLean.OwnershipMode) (a_1 : MicroLean.MicroLeanType) => Eq.refl.{1} MicroLean.MicroLeanType (MicroLean.LinearMicroType.base (MicroLean.LinearMicroType.qualified a a_1))
