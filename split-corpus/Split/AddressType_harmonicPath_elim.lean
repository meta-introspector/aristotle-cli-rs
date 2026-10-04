import Mathlib

set_option pp.all true
-- spec: AddressType.harmonicPath.elim : forall {motive : AddressType -> Sort.{u}} (t : AddressType), (Eq.{1} Nat (AddressType.ctorIdx t) 4) -> (motive AddressType.harmonicPath) -> (motive t)
def AddressType.harmonicPath.elim : forall {motive : AddressType -> Sort.{u}} (t : AddressType), (Eq.{1} Nat (AddressType.ctorIdx t) 4) -> (motive AddressType.harmonicPath) -> (motive t) :=
  fun {motive : AddressType -> Sort.{u}} (t : AddressType) (h : Eq.{1} Nat (AddressType.ctorIdx t) 4) (harmonicPath : motive AddressType.harmonicPath) => AddressType.ctorElim.{u} motive 4 t (Eq.symm.{1} Nat (AddressType.ctorIdx t) 4 h) (PULift.up.{u, u} (motive AddressType.harmonicPath) harmonicPath)
