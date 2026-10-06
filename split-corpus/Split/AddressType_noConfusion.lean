import Mathlib

set_option pp.all true
-- spec: AddressType.noConfusion : forall {P : Sort.{v._@.RequestProject.DA51.1523462449._hygCtx._hyg.14}} {x : AddressType} {y : AddressType}, (Eq.{1} AddressType x y) -> (AddressType.noConfusionType.{v._@.RequestProject.DA51.1523462449._hygCtx._hyg.14} P x y)
def AddressType.noConfusion : forall {P : Sort.{v._@.RequestProject.DA51.1523462449._hygCtx._hyg.14}} {x : AddressType} {y : AddressType}, (Eq.{1} AddressType x y) -> (AddressType.noConfusionType.{v._@.RequestProject.DA51.1523462449._hygCtx._hyg.14} P x y) :=
  fun {P : Sort.{v._@.RequestProject.DA51.1523462449._hygCtx._hyg.14}} {x : AddressType} {y : AddressType} (h : Eq.{1} AddressType x y) => noConfusionEnum.{1, 1, v._@.RequestProject.DA51.1523462449._hygCtx._hyg.14} AddressType Nat instDecidableEqNat AddressType.ctorIdx P x y h
