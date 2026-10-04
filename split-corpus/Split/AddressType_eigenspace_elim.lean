import Mathlib

set_option pp.all true
-- spec: AddressType.eigenspace.elim : forall {motive : AddressType -> Sort.{u}} (t : AddressType), (Eq.{1} Nat (AddressType.ctorIdx t) 6) -> (motive AddressType.eigenspace) -> (motive t)
def AddressType.eigenspace.elim : forall {motive : AddressType -> Sort.{u}} (t : AddressType), (Eq.{1} Nat (AddressType.ctorIdx t) 6) -> (motive AddressType.eigenspace) -> (motive t) :=
  fun {motive : AddressType -> Sort.{u}} (t : AddressType) (h : Eq.{1} Nat (AddressType.ctorIdx t) 6) (eigenspace : motive AddressType.eigenspace) => AddressType.ctorElim.{u} motive 6 t (Eq.symm.{1} Nat (AddressType.ctorIdx t) 6 h) (PULift.up.{u, u} (motive AddressType.eigenspace) eigenspace)
