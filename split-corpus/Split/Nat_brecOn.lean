import Mathlib

set_option pp.all true
-- spec: Nat.brecOn : forall {motive : Nat -> Sort.{u}} (t : Nat), (forall (t : Nat), (Nat.below.{u} motive t) -> (motive t)) -> (motive t)
def Nat.brecOn : forall {motive : Nat -> Sort.{u}} (t : Nat), (forall (t : Nat), (Nat.below.{u} motive t) -> (motive t)) -> (motive t) :=
  fun {motive : Nat -> Sort.{u}} (t : Nat) (F_1 : forall (t : Nat), (Nat.below.{u} motive t) -> (motive t)) => (Nat.brecOn.go.{u} motive t F_1).1
