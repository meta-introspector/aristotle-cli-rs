import Mathlib

set_option pp.all true
-- spec: Nat.lt : Nat -> Nat -> Prop
def Nat.lt : Nat -> Nat -> Prop :=
  fun (n : Nat) (m : Nat) => Nat.le (Nat.succ n) m
