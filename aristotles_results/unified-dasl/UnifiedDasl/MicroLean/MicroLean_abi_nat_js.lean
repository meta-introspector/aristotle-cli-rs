import Mathlib

-- spec: theorem MicroLean.abi_nat_js : Eq.{1} String (MicroLean.emitJs MicroLean.MicroLeanType.nat) "'pointer'"
theorem MicroLean.abi_nat_js : Eq.{1} String (MicroLean.emitJs MicroLean.MicroLeanType.nat) "'pointer'" :=
  rfl.{1} String (MicroLean.emitJs MicroLean.MicroLeanType.nat)
