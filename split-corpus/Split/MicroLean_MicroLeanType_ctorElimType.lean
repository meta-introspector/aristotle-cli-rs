import Mathlib

set_option pp.all true
-- spec: MicroLean.MicroLeanType.ctorElimType : forall {motive : MicroLean.MicroLeanType -> Sort.{u}}, Nat -> Sort.{max 1 u}
def MicroLean.MicroLeanType.ctorElimType : forall {motive : MicroLean.MicroLeanType -> Sort.{u}}, Nat -> Sort.{max 1 u} :=
  fun {motive : MicroLean.MicroLeanType -> Sort.{u}} (ctorIdx : Nat) => cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 1) (cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 0) (PULift.{u, u} (motive MicroLean.MicroLeanType.nat)) (PULift.{u, u} (motive MicroLean.MicroLeanType.bool))) (cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 2) (PULift.{u, u} (forall (domain : MicroLean.MicroLeanType) (codomain : MicroLean.MicroLeanType), motive (MicroLean.MicroLeanType.function domain codomain))) (cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 3) (PULift.{u, u} (forall (elem : MicroLean.MicroLeanType), motive (MicroLean.MicroLeanType.array elem))) (PULift.{u, u} (forall (fst : MicroLean.MicroLeanType) (snd : MicroLean.MicroLeanType), motive (MicroLean.MicroLeanType.prod fst snd)))))
