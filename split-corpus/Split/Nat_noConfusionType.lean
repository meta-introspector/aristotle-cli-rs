import Mathlib

set_option pp.all true
-- spec: Nat.noConfusionType : Sort.{u} -> Nat -> Nat -> Sort.{u}
def Nat.noConfusionType : Sort.{u} -> Nat -> Nat -> Sort.{u} :=
  fun (P : Sort.{u}) (t : Nat) (t' : Nat) => Nat.casesOn.{succ u} (fun (t : Nat) => Sort.{u}) t (Nat.casesOn.{succ u} (fun (t : Nat) => Sort.{u}) t' (P -> P) (fun (n : Nat) => P)) (fun (n : Nat) => Nat.casesOn.{succ u} (fun (t : Nat) => Sort.{u}) t' P (fun (n_1 : Nat) => ((Eq.{1} Nat n n_1) -> P) -> P))
