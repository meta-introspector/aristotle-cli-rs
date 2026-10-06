import Mathlib

-- spec: theorem MicroLean.emitJs.eq_1 : Eq.{1} String (MicroLean.emitJs MicroLean.MicroLeanType.nat) "'pointer'"
theorem MicroLean.emitJs.eq_1 : Eq.{1} String (MicroLean.emitJs MicroLean.MicroLeanType.nat) "'pointer'" :=
  Eq.refl.{1} String (MicroLean.emitJs MicroLean.MicroLeanType.nat)
