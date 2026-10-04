import Mathlib

set_option pp.all true
-- spec: MicroLean.MutMode.noConfusion : forall {P : Sort.{v._@.RequestProject.MicroLean.1521891665._hygCtx._hyg.6}} {x : MicroLean.MutMode} {y : MicroLean.MutMode}, (Eq.{1} MicroLean.MutMode x y) -> (MicroLean.MutMode.noConfusionType.{v._@.RequestProject.MicroLean.1521891665._hygCtx._hyg.6} P x y)
def MicroLean.MutMode.noConfusion : forall {P : Sort.{v._@.RequestProject.MicroLean.1521891665._hygCtx._hyg.6}} {x : MicroLean.MutMode} {y : MicroLean.MutMode}, (Eq.{1} MicroLean.MutMode x y) -> (MicroLean.MutMode.noConfusionType.{v._@.RequestProject.MicroLean.1521891665._hygCtx._hyg.6} P x y) :=
  fun {P : Sort.{v._@.RequestProject.MicroLean.1521891665._hygCtx._hyg.6}} {x : MicroLean.MutMode} {y : MicroLean.MutMode} (h : Eq.{1} MicroLean.MutMode x y) => noConfusionEnum.{1, 1, v._@.RequestProject.MicroLean.1521891665._hygCtx._hyg.6} MicroLean.MutMode Nat instDecidableEqNat MicroLean.MutMode.ctorIdx P x y h
