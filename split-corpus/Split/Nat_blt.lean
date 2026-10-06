import Mathlib

set_option pp.all true
-- spec: Nat.blt : Nat -> Nat -> Bool
def Nat.blt : Nat -> Nat -> Bool :=
  fun (a : Nat) (b : Nat) => Nat.ble (Nat.succ a) b
