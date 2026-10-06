import Mathlib

-- spec: theorem MicroLean.abi_nat_cpp : Eq.{1} String (MicroLean.emitCpp MicroLean.MicroLeanType.nat) "lean_object*"
theorem MicroLean.abi_nat_cpp : Eq.{1} String (MicroLean.emitCpp MicroLean.MicroLeanType.nat) "lean_object*" :=
  rfl.{1} String (MicroLean.emitCpp MicroLean.MicroLeanType.nat)
