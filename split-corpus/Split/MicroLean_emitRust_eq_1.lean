import Mathlib

-- spec: theorem MicroLean.emitRust.eq_1 : Eq.{1} String (MicroLean.emitRust MicroLean.MicroLeanType.nat) "*mut lean_object"
theorem MicroLean.emitRust.eq_1 : Eq.{1} String (MicroLean.emitRust MicroLean.MicroLeanType.nat) "*mut lean_object" :=
  Eq.refl.{1} String (MicroLean.emitRust MicroLean.MicroLeanType.nat)
