import Mathlib

set_option pp.all true
-- spec: Nat.xor : ([mdata borrowed:1 Nat]) -> ([mdata borrowed:1 Nat]) -> Nat
def Nat.xor : ([mdata borrowed:1 Nat]) -> ([mdata borrowed:1 Nat]) -> Nat :=
  Nat.bitwise (bne.{0} Bool (instBEqOfDecidableEq.{0} Bool instDecidableEqBool))
