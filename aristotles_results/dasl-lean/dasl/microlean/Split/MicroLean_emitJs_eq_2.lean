import Mathlib

-- spec: theorem MicroLean.emitJs.eq_2 : Eq.{1} String (MicroLean.emitJs MicroLean.MicroLeanType.bool) "'bool'"
theorem MicroLean.emitJs.eq_2 : Eq.{1} String (MicroLean.emitJs MicroLean.MicroLeanType.bool) "'bool'" :=
  Eq.refl.{1} String (MicroLean.emitJs MicroLean.MicroLeanType.bool)
