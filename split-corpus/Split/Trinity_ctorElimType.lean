import Mathlib

set_option pp.all true
-- spec: Trinity.ctorElimType : forall {motive : Trinity -> Sort.{u}}, Nat -> Sort.{max 1 u}
def Trinity.ctorElimType : forall {motive : Trinity -> Sort.{u}}, Nat -> Sort.{max 1 u} :=
  fun {motive : Trinity -> Sort.{u}} (ctorIdx : Nat) => cond.{succ (max 1 u)} Sort.{max 1 u} (Nat.ble ctorIdx 0) (PULift.{u, u} (motive Trinity.Three)) (PULift.{u, u} (forall (a._@._internal._hyg.0 : Something) (a_1._@._internal._hyg.0 : Something) (a_2._@._internal._hyg.0 : Something), motive (Trinity.DisjointUnion a._@._internal._hyg.0 a_1._@._internal._hyg.0 a_2._@._internal._hyg.0)))
