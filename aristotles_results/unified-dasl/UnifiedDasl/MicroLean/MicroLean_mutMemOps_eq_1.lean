import Mathlib

-- spec: theorem MicroLean.mutMemOps.eq_1 : forall (x._@.RequestProject.MicroLean.583257304._hygCtx._hyg.9 : String) (type : MicroLean.MicroLeanType), Eq.{1} (List.{0} String) (MicroLean.mutMemOps (MicroLean.MutLinearType.qualified MicroLean.MutMode.borrowed type) x._@.RequestProject.MicroLean.583257304._hygCtx._hyg.9) (List.nil.{0} String)
theorem MicroLean.mutMemOps.eq_1 : forall (x._@.RequestProject.MicroLean.583257304._hygCtx._hyg.9 : String) (type : MicroLean.MicroLeanType), Eq.{1} (List.{0} String) (MicroLean.mutMemOps (MicroLean.MutLinearType.qualified MicroLean.MutMode.borrowed type) x._@.RequestProject.MicroLean.583257304._hygCtx._hyg.9) (List.nil.{0} String) :=
  fun (x : String) (type : MicroLean.MicroLeanType) => Eq.refl.{1} (List.{0} String) (MicroLean.mutMemOps (MicroLean.MutLinearType.qualified MicroLean.MutMode.borrowed type) x)
