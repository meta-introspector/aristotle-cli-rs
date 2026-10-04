import Mathlib

set_option pp.all true
-- spec: WellFounded.Nat.eager : Nat -> Nat
def WellFounded.Nat.eager : Nat -> Nat :=
  fun (n : Nat) => ite.{1} Nat (Eq.{1} Bool (Nat.beq n n) Bool.true) (instDecidableEqBool (Nat.beq n n) Bool.true) n n
