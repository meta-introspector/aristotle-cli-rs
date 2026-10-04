import Mathlib

set_option pp.all true
-- spec: MicroLean.MutMode.ctorElimType : forall {motive : MicroLean.MutMode -> Sort.{u}}, Nat -> Sort.{max 1 u}
def MicroLean.MutMode.ctorElimType : forall {motive : MicroLean.MutMode -> Sort.{u}}, Nat -> Sort.{max 1 u} :=
  fun {motive : MicroLean.MutMode -> Sort.{u}} (ctorIdx : Nat) => cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 0) (PULift.{u, u} (motive MicroLean.MutMode.borrowed)) (cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 1) (PULift.{u, u} (motive MicroLean.MutMode.mutBorrow)) (PULift.{u, u} (motive MicroLean.MutMode.owned)))
