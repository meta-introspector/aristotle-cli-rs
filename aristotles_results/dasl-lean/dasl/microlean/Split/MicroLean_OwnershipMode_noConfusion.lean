import Mathlib

set_option pp.all true
-- spec: MicroLean.OwnershipMode.noConfusion : forall {P : Sort.{v._@.RequestProject.MicroLean.2111195904._hygCtx._hyg.6}} {x : MicroLean.OwnershipMode} {y : MicroLean.OwnershipMode}, (Eq.{1} MicroLean.OwnershipMode x y) -> (MicroLean.OwnershipMode.noConfusionType.{v._@.RequestProject.MicroLean.2111195904._hygCtx._hyg.6} P x y)
def MicroLean.OwnershipMode.noConfusion : forall {P : Sort.{v._@.RequestProject.MicroLean.2111195904._hygCtx._hyg.6}} {x : MicroLean.OwnershipMode} {y : MicroLean.OwnershipMode}, (Eq.{1} MicroLean.OwnershipMode x y) -> (MicroLean.OwnershipMode.noConfusionType.{v._@.RequestProject.MicroLean.2111195904._hygCtx._hyg.6} P x y) :=
  fun {P : Sort.{v._@.RequestProject.MicroLean.2111195904._hygCtx._hyg.6}} {x : MicroLean.OwnershipMode} {y : MicroLean.OwnershipMode} (h : Eq.{1} MicroLean.OwnershipMode x y) => noConfusionEnum.{1, 1, v._@.RequestProject.MicroLean.2111195904._hygCtx._hyg.6} MicroLean.OwnershipMode Nat instDecidableEqNat MicroLean.OwnershipMode.ctorIdx P x y h
