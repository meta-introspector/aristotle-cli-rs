import Mathlib

set_option pp.all true
-- spec: MicroLean.OwnershipMode.ctorElimType : forall {motive : MicroLean.OwnershipMode -> Sort.{u}}, Nat -> Sort.{max 1 u}
def MicroLean.OwnershipMode.ctorElimType : forall {motive : MicroLean.OwnershipMode -> Sort.{u}}, Nat -> Sort.{max 1 u} :=
  fun {motive : MicroLean.OwnershipMode -> Sort.{u}} (ctorIdx : Nat) => cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 0) (PULift.{u, u} (motive MicroLean.OwnershipMode.borrowed)) (PULift.{u, u} (motive MicroLean.OwnershipMode.owned))
