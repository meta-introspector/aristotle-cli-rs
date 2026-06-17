import Mathlib

set_option pp.all true
-- spec: AddressType.ctorElimType : forall {motive : AddressType -> Sort.{u}}, Nat -> Sort.{max 1 u}
def AddressType.ctorElimType : forall {motive : AddressType -> Sort.{u}}, Nat -> Sort.{max 1 u} :=
  fun {motive : AddressType -> Sort.{u}} (ctorIdx : Nat) => cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 3) (cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 1) (cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 0) (PULift.{u, u} (motive AddressType.monsterWalk)) (PULift.{u, u} (motive AddressType.astNode))) (cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 2) (PULift.{u, u} (motive AddressType.protocol)) (PULift.{u, u} (motive AddressType.nestedCID)))) (cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 5) (cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 4) (PULift.{u, u} (motive AddressType.harmonicPath)) (PULift.{u, u} (motive AddressType.shardId))) (cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 6) (PULift.{u, u} (motive AddressType.eigenspace)) (PULift.{u, u} (motive AddressType.hauptmodul))))
