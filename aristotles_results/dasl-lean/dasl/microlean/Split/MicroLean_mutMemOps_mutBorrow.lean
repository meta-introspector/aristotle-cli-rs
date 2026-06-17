import Mathlib

-- spec: theorem MicroLean.mutMemOps_mutBorrow : forall (t : MicroLean.MicroLeanType) (var : String), Eq.{1} (List.{0} String) (MicroLean.mutMemOps (MicroLean.MutLinearType.qualified MicroLean.MutMode.mutBorrow t) var) (List.nil.{0} String)
theorem MicroLean.mutMemOps_mutBorrow : forall (t : MicroLean.MicroLeanType) (var : String), Eq.{1} (List.{0} String) (MicroLean.mutMemOps (MicroLean.MutLinearType.qualified MicroLean.MutMode.mutBorrow t) var) (List.nil.{0} String) :=
  fun (t : MicroLean.MicroLeanType) (var : String) => Eq.refl.{1} (List.{0} String) (MicroLean.mutMemOps (MicroLean.MutLinearType.qualified MicroLean.MutMode.mutBorrow t) var)
