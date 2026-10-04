import Mathlib

set_option pp.all true
-- spec: Lean.Name.ctorElimType : forall {motive : Lean.Name -> Sort.{u}}, Nat -> Sort.{max 1 u}
def Lean.Name.ctorElimType : forall {motive : Lean.Name -> Sort.{u}}, Nat -> Sort.{max 1 u} :=
  fun {motive : Lean.Name -> Sort.{u}} (ctorIdx : Nat) => cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 0) (PULift.{u, u} (motive Lean.Name.anonymous)) (cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 1) (PULift.{u, u} (forall (pre : Lean.Name) (str : String), motive (Lean.Name.str pre str))) (PULift.{u, u} (forall (pre : Lean.Name) (i : Nat), motive (Lean.Name.num pre i))))
