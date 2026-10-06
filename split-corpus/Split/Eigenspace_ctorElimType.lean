import Mathlib

set_option pp.all true
-- spec: Eigenspace.ctorElimType : forall {motive : Eigenspace -> Sort.{u}}, Nat -> Sort.{max 1 u}
def Eigenspace.ctorElimType : forall {motive : Eigenspace -> Sort.{u}}, Nat -> Sort.{max 1 u} :=
  fun {motive : Eigenspace -> Sort.{u}} (ctorIdx : Nat) => cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 1) (cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 0) (PULift.{u, u} (motive Eigenspace.earth)) (PULift.{u, u} (motive Eigenspace.spoke))) (cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 2) (PULift.{u, u} (motive Eigenspace.hub)) (PULift.{u, u} (motive Eigenspace.clock)))
