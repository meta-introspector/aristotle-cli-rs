import Mathlib

-- spec: theorem MicroLean.mem_scalar_empty : forall (var : String), Eq.{1} (List.{0} String) (MicroLean.memOps MicroLean.MicroLeanType.bool var) (List.nil.{0} String)
theorem MicroLean.mem_scalar_empty : forall (var : String), Eq.{1} (List.{0} String) (MicroLean.memOps MicroLean.MicroLeanType.bool var) (List.nil.{0} String) :=
  fun (var : String) => rfl.{1} (List.{0} String) (MicroLean.memOps MicroLean.MicroLeanType.bool var)
