import Mathlib

set_option pp.all true
-- spec: AddressType.noConfusionType : Sort.{v._@.RequestProject.DA51.1523462449._hygCtx._hyg.13} -> AddressType -> AddressType -> Sort.{v._@.RequestProject.DA51.1523462449._hygCtx._hyg.13}
def AddressType.noConfusionType : Sort.{v._@.RequestProject.DA51.1523462449._hygCtx._hyg.13} -> AddressType -> AddressType -> Sort.{v._@.RequestProject.DA51.1523462449._hygCtx._hyg.13} :=
  fun (P : Sort.{v._@.RequestProject.DA51.1523462449._hygCtx._hyg.13}) (x : AddressType) (y : AddressType) => noConfusionTypeEnum.{1, 1, v._@.RequestProject.DA51.1523462449._hygCtx._hyg.13} AddressType Nat instDecidableEqNat AddressType.ctorIdx P x y
