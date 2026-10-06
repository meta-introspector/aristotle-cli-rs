import Mathlib

set_option pp.all true
-- spec: Nat.max : Nat -> Nat -> Nat
def Nat.max : Nat -> Nat -> Nat :=
  fun (n : Nat) (m : Nat) => Max.max.{0} Nat Nat.instMax n m
