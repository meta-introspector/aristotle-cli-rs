import Mathlib

-- spec: theorem MicroLean.projectOr_some : forall (mt : MicroLean.MicroLeanType), Eq.{1} MicroLean.MicroLeanType (MicroLean.projectOr (Option.some.{0} MicroLean.MicroLeanType mt)) mt
theorem MicroLean.projectOr_some : forall (mt : MicroLean.MicroLeanType), Eq.{1} MicroLean.MicroLeanType (MicroLean.projectOr (Option.some.{0} MicroLean.MicroLeanType mt)) mt :=
  fun (mt : MicroLean.MicroLeanType) => rfl.{1} MicroLean.MicroLeanType (MicroLean.projectOr (Option.some.{0} MicroLean.MicroLeanType mt))
