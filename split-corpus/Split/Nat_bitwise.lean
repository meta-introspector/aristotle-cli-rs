import Mathlib

set_option pp.all true
-- spec: Nat.bitwise : (Bool -> Bool -> Bool) -> Nat -> Nat -> Nat
def Nat.bitwise : (Bool -> Bool -> Bool) -> Nat -> Nat -> Nat :=
  fun (f : Bool -> Bool -> Bool) (n : Nat) (m : Nat) => Nat.bitwise._unary f (PSigma.mk.{1, 1} Nat (fun (n : Nat) => Nat) n m)
