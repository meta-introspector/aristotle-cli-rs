import Mathlib

set_option pp.all true
-- spec: Eigenspace.noConfusionType : Sort.{v._@.RequestProject.DA51.2506322757._hygCtx._hyg.9} -> Eigenspace -> Eigenspace -> Sort.{v._@.RequestProject.DA51.2506322757._hygCtx._hyg.9}
def Eigenspace.noConfusionType : Sort.{v._@.RequestProject.DA51.2506322757._hygCtx._hyg.9} -> Eigenspace -> Eigenspace -> Sort.{v._@.RequestProject.DA51.2506322757._hygCtx._hyg.9} :=
  fun (P : Sort.{v._@.RequestProject.DA51.2506322757._hygCtx._hyg.9}) (x : Eigenspace) (y : Eigenspace) => noConfusionTypeEnum.{1, 1, v._@.RequestProject.DA51.2506322757._hygCtx._hyg.9} Eigenspace Nat instDecidableEqNat Eigenspace.ctorIdx P x y
