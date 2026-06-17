import Mathlib

set_option pp.all true
-- spec: MicroLean.MutMode.noConfusionType : Sort.{v._@.RequestProject.MicroLean.1521891665._hygCtx._hyg.5} -> MicroLean.MutMode -> MicroLean.MutMode -> Sort.{v._@.RequestProject.MicroLean.1521891665._hygCtx._hyg.5}
def MicroLean.MutMode.noConfusionType : Sort.{v._@.RequestProject.MicroLean.1521891665._hygCtx._hyg.5} -> MicroLean.MutMode -> MicroLean.MutMode -> Sort.{v._@.RequestProject.MicroLean.1521891665._hygCtx._hyg.5} :=
  fun (P : Sort.{v._@.RequestProject.MicroLean.1521891665._hygCtx._hyg.5}) (x : MicroLean.MutMode) (y : MicroLean.MutMode) => noConfusionTypeEnum.{1, 1, v._@.RequestProject.MicroLean.1521891665._hygCtx._hyg.5} MicroLean.MutMode Nat instDecidableEqNat MicroLean.MutMode.ctorIdx P x y
