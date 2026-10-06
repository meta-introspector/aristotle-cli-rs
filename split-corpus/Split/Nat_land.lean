import Mathlib

set_option pp.all true
-- spec: Nat.land : ([mdata borrowed:1 Nat]) -> ([mdata borrowed:1 Nat]) -> Nat
def Nat.land : ([mdata borrowed:1 Nat]) -> ([mdata borrowed:1 Nat]) -> Nat :=
  Nat.bitwise Bool.and
