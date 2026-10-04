import Mathlib

-- spec: theorem MicroLean.emitCABI.eq_1 : Eq.{1} String (MicroLean.emitCABI MicroLean.MicroLeanType.bool) "uint8_t"
theorem MicroLean.emitCABI.eq_1 : Eq.{1} String (MicroLean.emitCABI MicroLean.MicroLeanType.bool) "uint8_t" :=
  Eq.refl.{1} String (MicroLean.emitCABI MicroLean.MicroLeanType.bool)
