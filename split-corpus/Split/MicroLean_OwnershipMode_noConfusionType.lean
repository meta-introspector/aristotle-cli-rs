import Mathlib

set_option pp.all true
-- spec: MicroLean.OwnershipMode.noConfusionType : Sort.{v._@.RequestProject.MicroLean.2111195904._hygCtx._hyg.5} -> MicroLean.OwnershipMode -> MicroLean.OwnershipMode -> Sort.{v._@.RequestProject.MicroLean.2111195904._hygCtx._hyg.5}
def MicroLean.OwnershipMode.noConfusionType : Sort.{v._@.RequestProject.MicroLean.2111195904._hygCtx._hyg.5} -> MicroLean.OwnershipMode -> MicroLean.OwnershipMode -> Sort.{v._@.RequestProject.MicroLean.2111195904._hygCtx._hyg.5} :=
  fun (P : Sort.{v._@.RequestProject.MicroLean.2111195904._hygCtx._hyg.5}) (x : MicroLean.OwnershipMode) (y : MicroLean.OwnershipMode) => noConfusionTypeEnum.{1, 1, v._@.RequestProject.MicroLean.2111195904._hygCtx._hyg.5} MicroLean.OwnershipMode Nat instDecidableEqNat MicroLean.OwnershipMode.ctorIdx P x y
