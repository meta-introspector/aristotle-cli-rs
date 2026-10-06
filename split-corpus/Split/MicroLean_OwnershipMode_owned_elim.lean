import Mathlib

set_option pp.all true
-- spec: MicroLean.OwnershipMode.owned.elim : forall {motive : MicroLean.OwnershipMode -> Sort.{u}} (t : MicroLean.OwnershipMode), (Eq.{1} Nat (MicroLean.OwnershipMode.ctorIdx t) 1) -> (motive MicroLean.OwnershipMode.owned) -> (motive t)
def MicroLean.OwnershipMode.owned.elim : forall {motive : MicroLean.OwnershipMode -> Sort.{u}} (t : MicroLean.OwnershipMode), (Eq.{1} Nat (MicroLean.OwnershipMode.ctorIdx t) 1) -> (motive MicroLean.OwnershipMode.owned) -> (motive t) :=
  fun {motive : MicroLean.OwnershipMode -> Sort.{u}} (t : MicroLean.OwnershipMode) (h : Eq.{1} Nat (MicroLean.OwnershipMode.ctorIdx t) 1) (owned : motive MicroLean.OwnershipMode.owned) => MicroLean.OwnershipMode.ctorElim.{u} motive 1 t (Eq.symm.{1} Nat (MicroLean.OwnershipMode.ctorIdx t) 1 h) (PULift.up.{u, u} (motive MicroLean.OwnershipMode.owned) owned)
