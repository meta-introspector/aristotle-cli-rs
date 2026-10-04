import Mathlib

set_option pp.all true
-- spec: AddressType.hauptmodul.elim : forall {motive : AddressType -> Sort.{u}} (t : AddressType), (Eq.{1} Nat (AddressType.ctorIdx t) 7) -> (motive AddressType.hauptmodul) -> (motive t)
def AddressType.hauptmodul.elim : forall {motive : AddressType -> Sort.{u}} (t : AddressType), (Eq.{1} Nat (AddressType.ctorIdx t) 7) -> (motive AddressType.hauptmodul) -> (motive t) :=
  fun {motive : AddressType -> Sort.{u}} (t : AddressType) (h : Eq.{1} Nat (AddressType.ctorIdx t) 7) (hauptmodul : motive AddressType.hauptmodul) => AddressType.ctorElim.{u} motive 7 t (Eq.symm.{1} Nat (AddressType.ctorIdx t) 7 h) (PULift.up.{u, u} (motive AddressType.hauptmodul) hauptmodul)
