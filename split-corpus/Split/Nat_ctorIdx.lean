import Mathlib

set_option pp.all true
-- spec: Nat.ctorIdx : Nat -> Nat
def Nat.ctorIdx : Nat -> Nat :=
  fun (x : Nat) => Nat.casesOn.{1} (fun (x : Nat) => Nat) x 0 (fun (n : Nat) => 1)
