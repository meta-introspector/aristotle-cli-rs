import Mathlib

set_option pp.all true
-- spec: Nat.brecOn.go : forall {motive : Nat -> Sort.{u}} (t : Nat), (forall (t : Nat), (Nat.below.{u} motive t) -> (motive t)) -> (PProd.{u, max 1 u} (motive t) (Nat.below.{u} motive t))
def Nat.brecOn.go : forall {motive : Nat -> Sort.{u}} (t : Nat), (forall (t : Nat), (Nat.below.{u} motive t) -> (motive t)) -> (PProd.{u, max 1 u} (motive t) (Nat.below.{u} motive t)) :=
  fun {motive : Nat -> Sort.{u}} (t : Nat) (F_1 : forall (t : Nat), (Nat.below.{u} motive t) -> (motive t)) => Nat.rec.{max 1 u} (fun (t : Nat) => PProd.{u, max 1 u} (motive t) (Nat.below.{u} motive t)) (PProd.mk.{u, max 1 u} (motive Nat.zero) PUnit.{max 1 u} (F_1 Nat.zero PUnit.unit.{max 1 u}) PUnit.unit.{max 1 u}) (fun (n : Nat) (n_ih : PProd.{u, max 1 u} (motive n) (Nat.below.{u} motive n)) => PProd.mk.{u, max 1 u} (motive (Nat.succ n)) (PProd.{u, max 1 u} (motive n) (Nat.below.{u} motive n)) (F_1 (Nat.succ n) n_ih) n_ih) t
