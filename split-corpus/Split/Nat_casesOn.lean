import Mathlib

set_option pp.all true
-- spec: Nat.casesOn : forall {motive : Nat -> Sort.{u}} (t : Nat), (motive Nat.zero) -> (forall (n : Nat), motive (Nat.succ n)) -> (motive t)
def Nat.casesOn : forall {motive : Nat -> Sort.{u}} (t : Nat), (motive Nat.zero) -> (forall (n : Nat), motive (Nat.succ n)) -> (motive t) :=
  fun {motive : Nat -> Sort.{u}} (t : Nat) (zero : motive Nat.zero) (succ : forall (n : Nat), motive (Nat.succ n)) => Nat.rec.{u} motive zero (fun (n : Nat) (n_ih : motive n) => succ n) t
