import Mathlib

-- spec: theorem MicroLean.emitCpp.eq_2 : Eq.{1} String (MicroLean.emitCpp MicroLean.MicroLeanType.bool) "bool"
theorem MicroLean.emitCpp.eq_2 : Eq.{1} String (MicroLean.emitCpp MicroLean.MicroLeanType.bool) "bool" :=
  Eq.refl.{1} String (MicroLean.emitCpp MicroLean.MicroLeanType.bool)
