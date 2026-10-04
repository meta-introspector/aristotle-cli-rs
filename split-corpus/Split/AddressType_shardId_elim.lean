import Mathlib

set_option pp.all true
-- spec: AddressType.shardId.elim : forall {motive : AddressType -> Sort.{u}} (t : AddressType), (Eq.{1} Nat (AddressType.ctorIdx t) 5) -> (motive AddressType.shardId) -> (motive t)
def AddressType.shardId.elim : forall {motive : AddressType -> Sort.{u}} (t : AddressType), (Eq.{1} Nat (AddressType.ctorIdx t) 5) -> (motive AddressType.shardId) -> (motive t) :=
  fun {motive : AddressType -> Sort.{u}} (t : AddressType) (h : Eq.{1} Nat (AddressType.ctorIdx t) 5) (shardId : motive AddressType.shardId) => AddressType.ctorElim.{u} motive 5 t (Eq.symm.{1} Nat (AddressType.ctorIdx t) 5 h) (PULift.up.{u, u} (motive AddressType.shardId) shardId)
