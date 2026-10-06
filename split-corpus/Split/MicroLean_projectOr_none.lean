import Mathlib

-- spec: theorem MicroLean.projectOr_none : Eq.{1} MicroLean.MicroLeanType (MicroLean.projectOr (Option.none.{0} MicroLean.MicroLeanType)) (MicroLean.MicroLeanType.function MicroLean.MicroLeanType.nat MicroLean.MicroLeanType.nat)
theorem MicroLean.projectOr_none : Eq.{1} MicroLean.MicroLeanType (MicroLean.projectOr (Option.none.{0} MicroLean.MicroLeanType)) (MicroLean.MicroLeanType.function MicroLean.MicroLeanType.nat MicroLean.MicroLeanType.nat) :=
  rfl.{1} MicroLean.MicroLeanType (MicroLean.projectOr (Option.none.{0} MicroLean.MicroLeanType))
