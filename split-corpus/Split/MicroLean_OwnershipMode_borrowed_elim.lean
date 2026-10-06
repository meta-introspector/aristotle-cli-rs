import Mathlib

set_option pp.all true
-- spec: MicroLean.OwnershipMode.borrowed.elim : forall {motive : MicroLean.OwnershipMode -> Sort.{u}} (t : MicroLean.OwnershipMode), (Eq.{1} Nat (MicroLean.OwnershipMode.ctorIdx t) 0) -> (motive MicroLean.OwnershipMode.borrowed) -> (motive t)
def MicroLean.OwnershipMode.borrowed.elim : forall {motive : MicroLean.OwnershipMode -> Sort.{u}} (t : MicroLean.OwnershipMode), (Eq.{1} Nat (MicroLean.OwnershipMode.ctorIdx t) 0) -> (motive MicroLean.OwnershipMode.borrowed) -> (motive t) :=
  fun {motive : MicroLean.OwnershipMode -> Sort.{u}} (t : MicroLean.OwnershipMode) (h : Eq.{1} Nat (MicroLean.OwnershipMode.ctorIdx t) 0) (borrowed : motive MicroLean.OwnershipMode.borrowed) => MicroLean.OwnershipMode.ctorElim.{u} motive 0 t (Eq.symm.{1} Nat (MicroLean.OwnershipMode.ctorIdx t) 0 h) (PULift.up.{u, u} (motive MicroLean.OwnershipMode.borrowed) borrowed)
