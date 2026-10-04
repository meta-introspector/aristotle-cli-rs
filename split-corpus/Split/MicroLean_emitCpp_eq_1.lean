import Mathlib

-- spec: theorem MicroLean.emitCpp.eq_1 : Eq.{1} String (MicroLean.emitCpp MicroLean.MicroLeanType.nat) "lean_object*"
theorem MicroLean.emitCpp.eq_1 : Eq.{1} String (MicroLean.emitCpp MicroLean.MicroLeanType.nat) "lean_object*" :=
  Eq.refl.{1} String (MicroLean.emitCpp MicroLean.MicroLeanType.nat)
