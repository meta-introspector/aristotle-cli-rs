import Mathlib

-- spec: theorem MicroLean.MutLinearType.base.eq_1 : forall (a : MicroLean.MutMode) (a_1 : MicroLean.MicroLeanType), Eq.{1} MicroLean.MicroLeanType (MicroLean.MutLinearType.base (MicroLean.MutLinearType.qualified a a_1)) a_1
theorem MicroLean.MutLinearType.base.eq_1 : forall (a : MicroLean.MutMode) (a_1 : MicroLean.MicroLeanType), Eq.{1} MicroLean.MicroLeanType (MicroLean.MutLinearType.base (MicroLean.MutLinearType.qualified a a_1)) a_1 :=
  fun (a : MicroLean.MutMode) (a_1 : MicroLean.MicroLeanType) => Eq.refl.{1} MicroLean.MicroLeanType (MicroLean.MutLinearType.base (MicroLean.MutLinearType.qualified a a_1))
