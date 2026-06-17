import Mathlib

-- spec: theorem MicroLean.linearMemOps.eq_1 : forall (x._@.RequestProject.MicroLean.1627873801._hygCtx._hyg.9 : String) (type : MicroLean.MicroLeanType), Eq.{1} (List.{0} String) (MicroLean.linearMemOps (MicroLean.LinearMicroType.qualified MicroLean.OwnershipMode.borrowed type) x._@.RequestProject.MicroLean.1627873801._hygCtx._hyg.9) (List.nil.{0} String)
theorem MicroLean.linearMemOps.eq_1 : forall (x._@.RequestProject.MicroLean.1627873801._hygCtx._hyg.9 : String) (type : MicroLean.MicroLeanType), Eq.{1} (List.{0} String) (MicroLean.linearMemOps (MicroLean.LinearMicroType.qualified MicroLean.OwnershipMode.borrowed type) x._@.RequestProject.MicroLean.1627873801._hygCtx._hyg.9) (List.nil.{0} String) :=
  fun (x : String) (type : MicroLean.MicroLeanType) => Eq.refl.{1} (List.{0} String) (MicroLean.linearMemOps (MicroLean.LinearMicroType.qualified MicroLean.OwnershipMode.borrowed type) x)
