import Mathlib

set_option pp.all true
-- spec: AddressType.protocol.elim : forall {motive : AddressType -> Sort.{u}} (t : AddressType), (Eq.{1} Nat (AddressType.ctorIdx t) 2) -> (motive AddressType.protocol) -> (motive t)
def AddressType.protocol.elim : forall {motive : AddressType -> Sort.{u}} (t : AddressType), (Eq.{1} Nat (AddressType.ctorIdx t) 2) -> (motive AddressType.protocol) -> (motive t) :=
  fun {motive : AddressType -> Sort.{u}} (t : AddressType) (h : Eq.{1} Nat (AddressType.ctorIdx t) 2) (protocol : motive AddressType.protocol) => AddressType.ctorElim.{u} motive 2 t (Eq.symm.{1} Nat (AddressType.ctorIdx t) 2 h) (PULift.up.{u, u} (motive AddressType.protocol) protocol)
