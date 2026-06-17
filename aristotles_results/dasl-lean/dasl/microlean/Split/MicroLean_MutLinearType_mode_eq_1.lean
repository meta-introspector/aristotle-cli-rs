import Mathlib

-- spec: theorem MicroLean.MutLinearType.mode.eq_1 : forall (a : MicroLean.MutMode) (a_1 : MicroLean.MicroLeanType), Eq.{1} MicroLean.MutMode (MicroLean.MutLinearType.mode (MicroLean.MutLinearType.qualified a a_1)) a
theorem MicroLean.MutLinearType.mode.eq_1 : forall (a : MicroLean.MutMode) (a_1 : MicroLean.MicroLeanType), Eq.{1} MicroLean.MutMode (MicroLean.MutLinearType.mode (MicroLean.MutLinearType.qualified a a_1)) a :=
  fun (a : MicroLean.MutMode) (a_1 : MicroLean.MicroLeanType) => Eq.refl.{1} MicroLean.MutMode (MicroLean.MutLinearType.mode (MicroLean.MutLinearType.qualified a a_1))
