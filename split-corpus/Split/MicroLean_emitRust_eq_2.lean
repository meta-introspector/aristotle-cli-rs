import Mathlib

-- spec: theorem MicroLean.emitRust.eq_2 : Eq.{1} String (MicroLean.emitRust MicroLean.MicroLeanType.bool) "bool"
theorem MicroLean.emitRust.eq_2 : Eq.{1} String (MicroLean.emitRust MicroLean.MicroLeanType.bool) "bool" :=
  Eq.refl.{1} String (MicroLean.emitRust MicroLean.MicroLeanType.bool)
