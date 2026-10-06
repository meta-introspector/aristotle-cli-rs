import Mathlib

set_option pp.all true
-- spec: AddressType.nestedCID.elim : forall {motive : AddressType -> Sort.{u}} (t : AddressType), (Eq.{1} Nat (AddressType.ctorIdx t) 3) -> (motive AddressType.nestedCID) -> (motive t)
def AddressType.nestedCID.elim : forall {motive : AddressType -> Sort.{u}} (t : AddressType), (Eq.{1} Nat (AddressType.ctorIdx t) 3) -> (motive AddressType.nestedCID) -> (motive t) :=
  fun {motive : AddressType -> Sort.{u}} (t : AddressType) (h : Eq.{1} Nat (AddressType.ctorIdx t) 3) (nestedCID : motive AddressType.nestedCID) => AddressType.ctorElim.{u} motive 3 t (Eq.symm.{1} Nat (AddressType.ctorIdx t) 3 h) (PULift.up.{u, u} (motive AddressType.nestedCID) nestedCID)
