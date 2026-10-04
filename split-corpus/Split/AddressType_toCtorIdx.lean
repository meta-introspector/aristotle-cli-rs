import Mathlib

set_option pp.all true
-- spec: AddressType.toCtorIdx : AddressType -> Nat
def AddressType.toCtorIdx : AddressType -> Nat :=
  AddressType.ctorIdx
