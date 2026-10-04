import Mathlib

set_option pp.all true
-- spec: Nat.lor : ([mdata borrowed:1 Nat]) -> ([mdata borrowed:1 Nat]) -> Nat
def Nat.lor : ([mdata borrowed:1 Nat]) -> ([mdata borrowed:1 Nat]) -> Nat :=
  Nat.bitwise Bool.or
