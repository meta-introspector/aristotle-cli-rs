import Mathlib

set_option pp.all true
-- spec: Nat.below : forall {motive : Nat -> Sort.{u}}, Nat -> Sort.{max 1 u}
def Nat.below : forall {motive : Nat -> Sort.{u}}, Nat -> Sort.{max 1 u} :=
  fun {motive : Nat -> Sort.{u}} (t : Nat) => Nat.rec.{succ (max 1 u)} (fun (t : Nat) => Sort.{max 1 u}) PUnit.{max 1 u} (fun (n : Nat) (n_ih : Sort.{max 1 u}) => PProd.{u, max 1 u} (motive n) n_ih) t
