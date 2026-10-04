import Mathlib

set_option pp.all true
-- spec: Eigenspace.noConfusion : forall {P : Sort.{v._@.RequestProject.DA51.2506322757._hygCtx._hyg.10}} {x : Eigenspace} {y : Eigenspace}, (Eq.{1} Eigenspace x y) -> (Eigenspace.noConfusionType.{v._@.RequestProject.DA51.2506322757._hygCtx._hyg.10} P x y)
def Eigenspace.noConfusion : forall {P : Sort.{v._@.RequestProject.DA51.2506322757._hygCtx._hyg.10}} {x : Eigenspace} {y : Eigenspace}, (Eq.{1} Eigenspace x y) -> (Eigenspace.noConfusionType.{v._@.RequestProject.DA51.2506322757._hygCtx._hyg.10} P x y) :=
  fun {P : Sort.{v._@.RequestProject.DA51.2506322757._hygCtx._hyg.10}} {x : Eigenspace} {y : Eigenspace} (h : Eq.{1} Eigenspace x y) => noConfusionEnum.{1, 1, v._@.RequestProject.DA51.2506322757._hygCtx._hyg.10} Eigenspace Nat instDecidableEqNat Eigenspace.ctorIdx P x y h
