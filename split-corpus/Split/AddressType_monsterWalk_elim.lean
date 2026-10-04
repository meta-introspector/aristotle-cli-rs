import Mathlib

set_option pp.all true
-- spec: AddressType.monsterWalk.elim : forall {motive : AddressType -> Sort.{u}} (t : AddressType), (Eq.{1} Nat (AddressType.ctorIdx t) 0) -> (motive AddressType.monsterWalk) -> (motive t)
def AddressType.monsterWalk.elim : forall {motive : AddressType -> Sort.{u}} (t : AddressType), (Eq.{1} Nat (AddressType.ctorIdx t) 0) -> (motive AddressType.monsterWalk) -> (motive t) :=
  fun {motive : AddressType -> Sort.{u}} (t : AddressType) (h : Eq.{1} Nat (AddressType.ctorIdx t) 0) (monsterWalk : motive AddressType.monsterWalk) => AddressType.ctorElim.{u} motive 0 t (Eq.symm.{1} Nat (AddressType.ctorIdx t) 0 h) (PULift.up.{u, u} (motive AddressType.monsterWalk) monsterWalk)
