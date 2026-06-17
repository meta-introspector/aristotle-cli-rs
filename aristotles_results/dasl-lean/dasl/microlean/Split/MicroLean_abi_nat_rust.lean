import Mathlib

-- spec: theorem MicroLean.abi_nat_rust : Eq.{1} String (MicroLean.emitRust MicroLean.MicroLeanType.nat) "*mut lean_object"
theorem MicroLean.abi_nat_rust : Eq.{1} String (MicroLean.emitRust MicroLean.MicroLeanType.nat) "*mut lean_object" :=
  rfl.{1} String (MicroLean.emitRust MicroLean.MicroLeanType.nat)
