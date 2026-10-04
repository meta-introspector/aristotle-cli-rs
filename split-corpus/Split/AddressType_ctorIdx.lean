import Mathlib

set_option pp.all true
-- spec: AddressType.ctorIdx : AddressType -> Nat
def AddressType.ctorIdx : AddressType -> Nat :=
  fun (x : AddressType) => AddressType.casesOn.{1} (fun (x : AddressType) => Nat) x 0 1 2 3 4 5 6 7
