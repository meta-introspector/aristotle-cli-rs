import Mathlib

set_option pp.all true
-- spec: AddressType.astNode.elim : forall {motive : AddressType -> Sort.{u}} (t : AddressType), (Eq.{1} Nat (AddressType.ctorIdx t) 1) -> (motive AddressType.astNode) -> (motive t)
def AddressType.astNode.elim : forall {motive : AddressType -> Sort.{u}} (t : AddressType), (Eq.{1} Nat (AddressType.ctorIdx t) 1) -> (motive AddressType.astNode) -> (motive t) :=
  fun {motive : AddressType -> Sort.{u}} (t : AddressType) (h : Eq.{1} Nat (AddressType.ctorIdx t) 1) (astNode : motive AddressType.astNode) => AddressType.ctorElim.{u} motive 1 t (Eq.symm.{1} Nat (AddressType.ctorIdx t) 1 h) (PULift.up.{u, u} (motive AddressType.astNode) astNode)
